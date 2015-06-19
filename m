Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE2997F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 13:34:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D8738F8033
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 11:34:40 -0700 (PDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id xixBmlVRM9EEQbZJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Jun 2015 11:34:38 -0700 (PDT)
Received: by wguu7 with SMTP id u7so24053124wgu.3
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 11:34:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABppvi58MHbtmhx226yM+e1ntR+bPvLqk6h80guW=2cimCzSxg@mail.gmail.com>
References: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>
	<8BF495B8-F444-415A-B7BF-5E1961C75817@sandeen.net>
	<CABppvi5ODWyjMw0pouAQ__SQ-aGb48PEyTCPU7Dt65Z1DhKmVA@mail.gmail.com>
	<556666B2.8060301@sandeen.net>
	<54A83597-7AE8-4846-944F-EEE7E2AD8B3C@sandeen.net>
	<CABppvi58MHbtmhx226yM+e1ntR+bPvLqk6h80guW=2cimCzSxg@mail.gmail.com>
Date: Fri, 19 Jun 2015 11:34:36 -0700
Message-ID: <CABppvi74JGacRjKpeKoJesunMo669GGVcLqg7A0WpN-yOD0mcw@mail.gmail.com>
Subject: Re: XFS crashes on VMs
From: Shrinand Javadekar <shrinand@maginatics.com>
Content-Type: multipart/mixed; boundary=f46d044303e41ba6d90518e32de3
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--f46d044303e41ba6d90518e32de3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I hit this problem again and captured the output of all the steps
while repairing the filesystem. Here's the crash:
http://pastie.org/private/prift1xjcc38s0jcvehvew

And the output of the xfs_repair steps (also attached if needed):
http://pastie.org/private/gvq3aiisudfhy69ezagw

Hope this can provide some insights.

-Shri

On Thu, May 28, 2015 at 11:08 AM, Shrinand Javadekar
<shrinand@maginatics.com> wrote:
> We'll try and reproduce this and capture the output of xfs_repair when
> it happens next. Will keep an eye on what else was happening in the
> infrastructure when it happens.
>
> FWIW, we've seen this in local VMware environment as well as when we
> were running on Amazon EC2 instances. So it doesn't seem hypervisor
> specific.
>
> On Wed, May 27, 2015 at 5:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote=
:
>> And did anything else "interesting" happen prior to the detection?
>>
>>> On May 27, 2015, at 7:52 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>
>>> You'll need to try to narrow down how it happened.
>>>
>>> The hexdumps in the logs show what data was in the buffer; in one case =
it was ascii, and was definitely not xfs metadata.
>>>
>>> Either:
>>>
>>> a) xfs wrote the wrong metadata - almost impossible, because we verify =
the data on write in the same way as we do on read
>>>
>>> b) xfs read the wrong block due to other metadata corruption.
>>>
>>> c) something corrupted the storage after it was written
>>>
>>> d) the storage returned the wrong data on a read request ...
>>>
>>> e) ???
>>>
>>> Did you save the xfs_repair output?  That might offer more clues.
>>>
>>> Unless you can reproduce it, it'll be hard to come up with a definitive=
 root cause... can you try?
>>>
>>> -Eric
>>>
>>>
>>>> On 5/27/15 7:03 PM, Shrinand Javadekar wrote:
>>>> Thanks Eric,
>>>>
>>>> We ran xfs_repair and were able to get it back into a running state.
>>>> This is fine for a test & dev but in production it won't be
>>>> acceptable. What other data do we need to get to the bottom of this?
>>>>
>>>>> On Wed, May 27, 2015 at 4:27 PM, Eric Sandeen <sandeen@sandeen.net> w=
rote:
>>>>> That's not a crash. That is xfs detecting on disk corruption which li=
kely happened at some time prior. You should unmount and run xfs_repair, po=
ssibly with =E2=80=93n first if you would like to do a dry run to see what =
it might do.  If you get fresh corruption after a full repair, then that be=
comes more interesting. It's possible that you have a problem with the unde=
rlying block layer or it's possible that it is an xfs bug -  but I think th=
is is not something that we have seen before.
>>>>>
>>>>> Eric
>>>>>
>>>>>> On May 27, 2015, at 6:06 PM, Shrinand Javadekar <shrinand@maginatics=
.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I am running Openstack Swift in a VM with XFS as the underlying
>>>>>> filesystem. This is generating a metadata heavy workload on XFS.
>>>>>> Essentially, it is creating a new directory and a new file (256KB) i=
n
>>>>>> that directory. This file has extended attributes of size 243 bytes.
>>>>>>
>>>>>> I am seeing the following two crashes of the machine:
>>>>>>
>>>>>> http://pastie.org/pastes/10210974/text?key=3Dxdmfvaocvawnyfmkb06zg
>>>>>>
>>>>>> AND
>>>>>>
>>>>>> http://pastie.org/pastes/10210975/text?key=3Drkiljsdaucrk7frprzgqq
>>>>>>
>>>>>> I have only seen these when running in a VM. We have run several tes=
ts
>>>>>> on physical server but have never seen these problems.
>>>>>>
>>>>>> Are there any known issues with XFS running on VMs?
>>>>>>
>>>>>> Thanks in advance.
>>>>>> -Shri
>>>>>>
>>>>>> _______________________________________________
>>>>>> xfs mailing list
>>>>>> xfs@oss.sgi.com
>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs

--f46d044303e41ba6d90518e32de3
Content-Type: application/octet-stream; name=xfs_crash
Content-Disposition: attachment; filename=xfs_crash
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ib3ye5m20

cm9vdEBmb29kcy0xMjovaG9tZS9tYWdpbmF0aWNzIyB4ZnNfcmVwYWlyIC9kZXYvbWFwcGVyL1Ry
b2xsR3JvdXAtVHJvbGxWb2x1bWUKUGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2Nr
Li4uClBoYXNlIDIgLSB1c2luZyBpbnRlcm5hbCBsb2cKICAgICAgICAtIHplcm8gbG9nLi4uCiAg
ICAgICAgRVJST1I6IFRoZSBmaWxlc3lzdGVtIGhhcyB2YWx1YWJsZSBtZXRhZGF0YSBjaGFuZ2Vz
IGluIGEgbG9nIHdoaWNoIG5lZWRzIHRvCiAgICAgICAgYmUgcmVwbGF5ZWQuICBNb3VudCB0aGUg
ZmlsZXN5c3RlbSB0byByZXBsYXkgdGhlIGxvZywgYW5kIHVubW91bnQgaXQgYmVmb3JlCiAgICAg
ICAgcmUtcnVubmluZyB4ZnNfcmVwYWlyLiAgSWYgeW91IGFyZSB1bmFibGUgdG8gbW91bnQgdGhl
IGZpbGVzeXN0ZW0sIHRoZW4gdXNlCiAgICAgICAgdGhlIC1MIG9wdGlvbiB0byBkZXN0cm95IHRo
ZSBsb2cgYW5kIGF0dGVtcHQgYSByZXBhaXIuCiAgICAgICAgTm90ZSB0aGF0IGRlc3Ryb3lpbmcg
dGhlIGxvZyBtYXkgY2F1c2UgY29ycnVwdGlvbiAtLSBwbGVhc2UgYXR0ZW1wdCBhIG1vdW50CiAg
ICAgICAgb2YgdGhlIGZpbGVzeXN0ZW0gYmVmb3JlIGRvaW5nIHRoaXMuCgoKcm9vdEBmb29kcy0x
MjovaG9tZS9tYWdpbmF0aWNzIyBtb3VudCAvZGV2L21hcHBlci9Ucm9sbEdyb3VwLVRyb2xsVm9s
dW1lCnJvb3RAZm9vZHMtMTI6L2hvbWUvbWFnaW5hdGljcyMgbW91bnQKLi4uCi9kZXYvbWFwcGVy
L1Ryb2xsR3JvdXAtVHJvbGxWb2x1bWUgb24gL2x2bSB0eXBlIHhmcyAocncsbm9leGVjLG5vc3Vp
ZCxub2Rldixub2F0aW1lLG5vZGlyYXRpbWUsbm9iYXJyaWVyLGxvZ2J1ZnM9OCkKCnJvb3RAZm9v
ZHMtMTI6L2hvbWUvbWFnaW5hdGljcyMgdW1vdW50IC9sdm0KCnJvb3RAZm9vZHMtMTI6L2hvbWUv
bWFnaW5hdGljcyMgbW91bnQKPG5vIC9sdm0+Cgpyb290QGZvb2RzLTEyOi9ob21lL21hZ2luYXRp
Y3M6IHhmc19yZXBhaXIgL2Rldi9tYXBwZXIvVHJvbGxHcm91cC1Ucm9sbFZvbHVtZQpyb290QGZv
b2RzLTEyOi9ob21lL21hZ2luYXRpY3MjIHRhaWwgLWYgcmVwYWlyX291dHB1dApQaGFzZSAxIC0g
ZmluZCBhbmQgdmVyaWZ5IHN1cGVyYmxvY2suLi4KUGhhc2UgMiAtIHVzaW5nIGludGVybmFsIGxv
ZwogICAgICAgIC0gemVybyBsb2cuLi4KICAgICAgICAtIHNjYW4gZmlsZXN5c3RlbSBmcmVlc3Bh
Y2UgYW5kIGlub2RlIG1hcHMuLi4KICAgICAgICAtIGZvdW5kIHJvb3QgaW5vZGUgY2h1bmsKUGhh
c2UgMyAtIGZvciBlYWNoIEFHLi4uCiAgICAgICAgLSBzY2FuIGFuZCBjbGVhciBhZ2kgdW5saW5r
ZWQgbGlzdHMuLi4KICAgICAgICAtIHByb2Nlc3Mga25vd24gaW5vZGVzIGFuZCBwZXJmb3JtIGlu
b2RlIGRpc2NvdmVyeS4uLgogICAgICAgIC0gYWdubyA9IDAKICAgICAgICAtIGFnbm8gPSAxCiAg
ICAgICAgLSBhZ25vID0gMgogICAgICAgIC0gYWdubyA9IDMKICAgICAgICAtIHByb2Nlc3MgbmV3
bHkgZGlzY292ZXJlZCBpbm9kZXMuLi4KUGhhc2UgNCAtIGNoZWNrIGZvciBkdXBsaWNhdGUgYmxv
Y2tzLi4uCiAgICAgICAgLSBzZXR0aW5nIHVwIGR1cGxpY2F0ZSBleHRlbnQgbGlzdC4uLgogICAg
ICAgIC0gY2hlY2sgZm9yIGlub2RlcyBjbGFpbWluZyBkdXBsaWNhdGUgYmxvY2tzLi4uCiAgICAg
ICAgLSBhZ25vID0gMAogICAgICAgIC0gYWdubyA9IDEKICAgICAgICAtIGFnbm8gPSAyCiAgICAg
ICAgLSBhZ25vID0gMwpQaGFzZSA1IC0gcmVidWlsZCBBRyBoZWFkZXJzIGFuZCB0cmVlcy4uLgog
ICAgICAgIC0gcmVzZXQgc3VwZXJibG9jay4uLgpQaGFzZSA2IC0gY2hlY2sgaW5vZGUgY29ubmVj
dGl2aXR5Li4uCiAgICAgICAgLSByZXNldHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0bWFw
IGFuZCBzdW1tYXJ5IGlub2RlcwogICAgICAgIC0gdHJhdmVyc2luZyBmaWxlc3lzdGVtIC4uLgog
ICAgICAgIC0gdHJhdmVyc2FsIGZpbmlzaGVkIC4uLgogICAgICAgIC0gbW92aW5nIGRpc2Nvbm5l
Y3RlZCBpbm9kZXMgdG8gbG9zdCtmb3VuZCAuLi4KUGhhc2UgNyAtIHZlcmlmeSBhbmQgY29ycmVj
dCBsaW5rIGNvdW50cy4uLgpkb25lCg==
--f46d044303e41ba6d90518e32de3
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--f46d044303e41ba6d90518e32de3--
