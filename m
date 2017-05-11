Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:34136 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756398AbdEKPku (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Thu, 11 May 2017 11:40:50 -0400
Message-Id: <5914A2220200007800158F08@prv-mh.provo.novell.com>
Date: Thu, 11 May 2017 09:40:50 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <208b91b4-9f5e-b204-52d7-4b7706bdc8fe@sandeen.net>
 <59149B810200007800158EE1@prv-mh.provo.novell.com>
 <3ccd7176-21b0-22a7-0dca-345ae7d41e5d@sandeen.net>
In-Reply-To: <3ccd7176-21b0-22a7-0dca-345ae7d41e5d@sandeen.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartB189F112.1__="
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartB189F112.1__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On 11.05.17 at 17:16, <sandeen@sandeen.net> wrote:
> On 5/11/17 10:12 AM, Jan Beulich wrote:
>>>>> On 11.05.17 at 16:58, <sandeen@sandeen.net> wrote:
>>> Oh, hm.  What caused that crash, do you have logs prior to it?
>>=20
>> Nothing at all in the logs; the crashes were hypervisor ones in
>> both instances.
>=20
> ok, so this guest was fine, other than getting taken out by the
> hypervisor?

Well, it was the host (Xen Dom0) actually. But yes, the Dom0 part
of the system was entirely fine.

>>>> I didn't try xfs_repair-ing
>>>> the volume in this second instance, as the result from doing so in
>>>> the first instance was only permanent re-occurrence (and
>>>> apparently spreading) of the problem. It may be interesting that
>>>> xfs_check finds only this one corrupted inode, while the kernel
>>>> also finds at least one more:
>>>
>>> xfs_repair -n would be safe, what does it say?  (mount/unmount
>>> first, to clear the log)
>>=20
>> So are you saying "xfs_repair -n" is not the same as "xfs_check"?
>=20
> Different body of code, even though they perform similar functions.

Output for both volumes attached.

>>>> In any event I think there are two problems: The corruption itself
>>>> (possibly an issue with recent enough upstream kernels only) and
>>>> the fact that running xfs_repair doesn't help in these cases. I'm
>>>> attaching xfs_check and xfs_metadump warning output for both
>>>> affected volumes in this second instance. The full files
>>>> xfs_metadump -agow produced can be provided upon request
>>>> (500Mb and 80Mb uncompressed respectively).
>>>
>>> can you provide one or both compressed xfs_metadumps offline?
>>> (No need to post URL to the list)
>>=20
>> Well, I have no idea where to upload it to, all the sites I know of
>> only accept text kind of data, and I don't think that would be
>> suitable here. (I'm sorry for my ignorance, but that's not something
>> I ever had a need to do.)
>=20
> How small does the 80mb one compress with xz?  You may be able to just
> mail it my way.  If not I'll find another option.

4.6 Mb. Is that small enough for your mailbox?

Jan


--=__PartB189F112.1__=
Content-Type: application/octet-stream; name="sda1.dry"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="sda1.dry"

UGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uClBoYXNlIDIgLSB1c2luZyBp
bnRlcm5hbCBsb2cKICAgICAgICAtIHNjYW4gZmlsZXN5c3RlbSBmcmVlc3BhY2UgYW5kIGlub2Rl
IG1hcHMuLi4KICAgICAgICAtIGZvdW5kIHJvb3QgaW5vZGUgY2h1bmsKUGhhc2UgMyAtIGZvciBl
YWNoIEFHLi4uCiAgICAgICAgLSBzY2FuIChidXQgZG9uJ3QgY2xlYXIpIGFnaSB1bmxpbmtlZCBs
aXN0cy4uLgogICAgICAgIC0gcHJvY2VzcyBrbm93biBpbm9kZXMgYW5kIHBlcmZvcm0gaW5vZGUg
ZGlzY292ZXJ5Li4uCiAgICAgICAgLSBhZ25vID0gMAppbm9kZSAxMDQ4MTIwNjYgaGFzIFJUIGZs
YWcgc2V0IGJ1dCB0aGVyZSBpcyBubyBSVCBkZXZpY2UKaW5vZGUgMTA0ODEyMDY2IGhhcyBSVCBm
bGFnIHNldCBidXQgdGhlcmUgaXMgbm8gUlQgZGV2aWNlCiwgd291bGQgZml4IGJhZCBmbGFncy4K
ICAgICAgICAtIGFnbm8gPSAxCiAgICAgICAgLSBhZ25vID0gMgpCYWQgZmxhZ3Mgc2V0IGluIGlu
b2RlIDU3NjI1NDYyNwpCYWQgZmxhZ3Mgc2V0IGluIGlub2RlIDU3NjI1NDYzNgpCYWQgZmxhZ3Mg
c2V0IGluIGlub2RlIDU3NjI1NDYyNwosIHdvdWxkIGZpeCBiYWQgZmxhZ3MuCmZvdW5kIGlub2Rl
IDU3NjI1NDYyNyBjbGFpbWluZyB0byBiZSBhIHJlYWwtdGltZSBmaWxlCndvdWxkIGhhdmUgY2xl
YXJlZCBpbm9kZSA1NzYyNTQ2MjcKQmFkIGZsYWdzIHNldCBpbiBpbm9kZSA1NzYyNTQ2MzYKLCB3
b3VsZCBmaXggYmFkIGZsYWdzLgogICAgICAgIC0gYWdubyA9IDMKICAgICAgICAtIHByb2Nlc3Mg
bmV3bHkgZGlzY292ZXJlZCBpbm9kZXMuLi4KUGhhc2UgNCAtIGNoZWNrIGZvciBkdXBsaWNhdGUg
YmxvY2tzLi4uCiAgICAgICAgLSBzZXR0aW5nIHVwIGR1cGxpY2F0ZSBleHRlbnQgbGlzdC4uLgog
ICAgICAgIC0gY2hlY2sgZm9yIGlub2RlcyBjbGFpbWluZyBkdXBsaWNhdGUgYmxvY2tzLi4uCiAg
ICAgICAgLSBhZ25vID0gMAogICAgICAgIC0gYWdubyA9IDIKICAgICAgICAtIGFnbm8gPSAxCiAg
ICAgICAgLSBhZ25vID0gMwpCYWQgZmxhZ3Mgc2V0IGluIGlub2RlIDU3NjI1NDYyNwosIHdvdWxk
IGZpeCBiYWQgZmxhZ3MuCmZvdW5kIGlub2RlIDU3NjI1NDYyNyBjbGFpbWluZyB0byBiZSBhIHJl
YWwtdGltZSBmaWxlCndvdWxkIGhhdmUgY2xlYXJlZCBpbm9kZSA1NzYyNTQ2MjcKQmFkIGZsYWdz
IHNldCBpbiBpbm9kZSA1NzYyNTQ2MzYKLCB3b3VsZCBmaXggYmFkIGZsYWdzLgplbnRyeSAibWFp
bi1odm02NC5vIiBhdCBibG9jayAwIG9mZnNldCAxNDAwIGluIGRpcmVjdG9yeSBpbm9kZSA1OTg0
NDg5MTcgcmVmZXJlbmNlcyBmcmVlIGlub2RlIDU3NjI1NDYyNwoJd291bGQgY2xlYXIgaW5vZGUg
bnVtYmVyIGluIGVudHJ5IGF0IG9mZnNldCAxNDAwLi4uCmlub2RlIDEwNDgxMjA2NiBoYXMgUlQg
ZmxhZyBzZXQgYnV0IHRoZXJlIGlzIG5vIFJUIGRldmljZQosIHdvdWxkIGZpeCBiYWQgZmxhZ3Mu
Ck5vIG1vZGlmeSBmbGFnIHNldCwgc2tpcHBpbmcgcGhhc2UgNQpQaGFzZSA2IC0gY2hlY2sgaW5v
ZGUgY29ubmVjdGl2aXR5Li4uCiAgICAgICAgLSB0cmF2ZXJzaW5nIGZpbGVzeXN0ZW0gLi4uCmNv
cnJ1cHQgZGlub2RlIDEwNDgxMjA2NiwgaGFzIHJlYWx0aW1lIGZsYWcgc2V0LiAgVGhpcyBpcyBh
IGJ1Zy4KUGxlYXNlIGNhcHR1cmUgdGhlIGZpbGVzeXN0ZW0gbWV0YWRhdGEgd2l0aCB4ZnNfbWV0
YWR1bXAgYW5kCnJlcG9ydCBpdCB0byB4ZnNAb3NzLnNnaS5jb20uCmNhY2hlX25vZGVfcHVyZ2U6
IHJlZmNvdW50IHdhcyAxLCBub3QgemVybyAobm9kZT0weDdmOTA0MGQyMGU0MCkKY291bGRuJ3Qg
bWFwIGlub2RlIDEwNDgxMjA2NiwgZXJyID0gMTE3CmVudHJ5ICJtYWluLWh2bTY0Lm8iIGluIGRp
cmVjdG9yeSBpbm9kZSA1OTg0NDg5MTcgcG9pbnRzIHRvIGZyZWUgaW5vZGUgNTc2MjU0NjI3LCB3
b3VsZCBqdW5rIGVudHJ5CmJhZCBoYXNoIHRhYmxlIGZvciBkaXJlY3RvcnkgaW5vZGUgNTk4NDQ4
OTE3IChubyBkYXRhIGVudHJ5KTogd291bGQgcmVidWlsZAogICAgICAgIC0gdHJhdmVyc2FsIGZp
bmlzaGVkIC4uLgogICAgICAgIC0gbW92aW5nIGRpc2Nvbm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtm
b3VuZCAuLi4KZGlzY29ubmVjdGVkIGlub2RlIDkzMjAxMTcsIHdvdWxkIG1vdmUgdG8gbG9zdCtm
b3VuZApkaXNjb25uZWN0ZWQgaW5vZGUgOTMyMDExOSwgd291bGQgbW92ZSB0byBsb3N0K2ZvdW5k
CmRpc2Nvbm5lY3RlZCBpbm9kZSA5MzIwMTIwLCB3b3VsZCBtb3ZlIHRvIGxvc3QrZm91bmQKZGlz
Y29ubmVjdGVkIGlub2RlIDkzMjAxMjEsIHdvdWxkIG1vdmUgdG8gbG9zdCtmb3VuZApkaXNjb25u
ZWN0ZWQgaW5vZGUgOTMyMDEyMywgd291bGQgbW92ZSB0byBsb3N0K2ZvdW5kCmRpc2Nvbm5lY3Rl
ZCBpbm9kZSAxMDQ4MTIwNjcsIHdvdWxkIG1vdmUgdG8gbG9zdCtmb3VuZApkaXNjb25uZWN0ZWQg
aW5vZGUgMTA0ODEyMDY4LCB3b3VsZCBtb3ZlIHRvIGxvc3QrZm91bmQKUGhhc2UgNyAtIHZlcmlm
eSBsaW5rIGNvdW50cy4uLgp3b3VsZCBoYXZlIHJlc2V0IGlub2RlIDEwNDgxMjA2NiBubGlua3Mg
ZnJvbSAyIHRvIDEKTm8gbW9kaWZ5IGZsYWcgc2V0LCBza2lwcGluZyBmaWxlc3lzdGVtIGZsdXNo
IGFuZCBleGl0aW5nLgo=

--=__PartB189F112.1__=
Content-Type: application/octet-stream; name="sdb8.dry"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="sdb8.dry"

UGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uClBoYXNlIDIgLSB1c2luZyBp
bnRlcm5hbCBsb2cKICAgICAgICAtIHNjYW4gZmlsZXN5c3RlbSBmcmVlc3BhY2UgYW5kIGlub2Rl
IG1hcHMuLi4KICAgICAgICAtIGZvdW5kIHJvb3QgaW5vZGUgY2h1bmsKUGhhc2UgMyAtIGZvciBl
YWNoIEFHLi4uCiAgICAgICAgLSBzY2FuIChidXQgZG9uJ3QgY2xlYXIpIGFnaSB1bmxpbmtlZCBs
aXN0cy4uLgogICAgICAgIC0gcHJvY2VzcyBrbm93biBpbm9kZXMgYW5kIHBlcmZvcm0gaW5vZGUg
ZGlzY292ZXJ5Li4uCiAgICAgICAgLSBhZ25vID0gMApCYWQgZmxhZ3Mgc2V0IGluIGlub2RlIDc2
NApCYWQgZmxhZ3Mgc2V0IGluIGlub2RlIDc2NAosIHdvdWxkIGZpeCBiYWQgZmxhZ3MuCmZvdW5k
IGlub2RlIDc2NCBjbGFpbWluZyB0byBiZSBhIHJlYWwtdGltZSBmaWxlCndvdWxkIGhhdmUgY2xl
YXJlZCBpbm9kZSA3NjQKaW5vZGUgMjA2OCBoYXMgUlQgZmxhZyBzZXQgYnV0IHRoZXJlIGlzIG5v
IFJUIGRldmljZQpkaXJlY3RvcnkgZmxhZ3Mgc2V0IG9uIG5vbi1kaXJlY3RvcnkgaW5vZGUgMjA2
OAppbm9kZSAyMDY4IGhhcyBSVCBmbGFnIHNldCBidXQgdGhlcmUgaXMgbm8gUlQgZGV2aWNlCmRp
cmVjdG9yeSBmbGFncyBzZXQgb24gbm9uLWRpcmVjdG9yeSBpbm9kZSAyMDY4Ciwgd291bGQgZml4
IGJhZCBmbGFncy4KICAgICAgICAtIGFnbm8gPSAxCmlub2RlIDI2ODQ0ODY3NCBoYXMgUlQgZmxh
ZyBzZXQgYnV0IHRoZXJlIGlzIG5vIFJUIGRldmljZQpkaXJlY3RvcnkgZmxhZ3Mgc2V0IG9uIG5v
bi1kaXJlY3RvcnkgaW5vZGUgMjY4NDQ4Njc0Cmlub2RlIDI2ODQ0ODY3NCBoYXMgUlQgZmxhZyBz
ZXQgYnV0IHRoZXJlIGlzIG5vIFJUIGRldmljZQpkaXJlY3RvcnkgZmxhZ3Mgc2V0IG9uIG5vbi1k
aXJlY3RvcnkgaW5vZGUgMjY4NDQ4Njc0Ciwgd291bGQgZml4IGJhZCBmbGFncy4KZm91bmQgaW5v
ZGUgMjY4NDQ4Njc0IGNsYWltaW5nIHRvIGJlIGEgcmVhbC10aW1lIGZpbGUKd291bGQgaGF2ZSBj
bGVhcmVkIGlub2RlIDI2ODQ0ODY3NAogICAgICAgIC0gYWdubyA9IDIKICAgICAgICAtIGFnbm8g
PSAzCiAgICAgICAgLSBwcm9jZXNzIG5ld2x5IGRpc2NvdmVyZWQgaW5vZGVzLi4uClBoYXNlIDQg
LSBjaGVjayBmb3IgZHVwbGljYXRlIGJsb2Nrcy4uLgogICAgICAgIC0gc2V0dGluZyB1cCBkdXBs
aWNhdGUgZXh0ZW50IGxpc3QuLi4KICAgICAgICAtIGNoZWNrIGZvciBpbm9kZXMgY2xhaW1pbmcg
ZHVwbGljYXRlIGJsb2Nrcy4uLgogICAgICAgIC0gYWdubyA9IDAKICAgICAgICAtIGFnbm8gPSAx
CiAgICAgICAgLSBhZ25vID0gMgogICAgICAgIC0gYWdubyA9IDMKQmFkIGZsYWdzIHNldCBpbiBp
bm9kZSA3NjQKLCB3b3VsZCBmaXggYmFkIGZsYWdzLgpmb3VuZCBpbm9kZSA3NjQgY2xhaW1pbmcg
dG8gYmUgYSByZWFsLXRpbWUgZmlsZQp3b3VsZCBoYXZlIGNsZWFyZWQgaW5vZGUgNzY0CmVudHJ5
ICJ0ZGIiIGluIHNob3J0Zm9ybSBkaXJlY3RvcnkgNzc5IHJlZmVyZW5jZXMgZnJlZSBpbm9kZSA3
NjQKd291bGQgaGF2ZSBqdW5rZWQgZW50cnkgInRkYiIgaW4gZGlyZWN0b3J5IGlub2RlIDc3OQpp
bm9kZSAyNjg0NDg2NzQgaGFzIFJUIGZsYWcgc2V0IGJ1dCB0aGVyZSBpcyBubyBSVCBkZXZpY2UK
ZGlyZWN0b3J5IGZsYWdzIHNldCBvbiBub24tZGlyZWN0b3J5IGlub2RlIDI2ODQ0ODY3NAosIHdv
dWxkIGZpeCBiYWQgZmxhZ3MuCmZvdW5kIGlub2RlIDI2ODQ0ODY3NCBjbGFpbWluZyB0byBiZSBh
IHJlYWwtdGltZSBmaWxlCndvdWxkIGhhdmUgY2xlYXJlZCBpbm9kZSAyNjg0NDg2NzQKZW50cnkg
IjAiIGluIHNob3J0Zm9ybSBkaXJlY3RvcnkgMjY4NDQ4Njc2IHJlZmVyZW5jZXMgZnJlZSBpbm9k
ZSAyNjg0NDg2NzQKd291bGQgaGF2ZSBqdW5rZWQgZW50cnkgIjAiIGluIGRpcmVjdG9yeSBpbm9k
ZSAyNjg0NDg2NzYKaW5vZGUgMjA2OCBoYXMgUlQgZmxhZyBzZXQgYnV0IHRoZXJlIGlzIG5vIFJU
IGRldmljZQpkaXJlY3RvcnkgZmxhZ3Mgc2V0IG9uIG5vbi1kaXJlY3RvcnkgaW5vZGUgMjA2OAos
IHdvdWxkIGZpeCBiYWQgZmxhZ3MuCk5vIG1vZGlmeSBmbGFnIHNldCwgc2tpcHBpbmcgcGhhc2Ug
NQpQaGFzZSA2IC0gY2hlY2sgaW5vZGUgY29ubmVjdGl2aXR5Li4uCiAgICAgICAgLSB0cmF2ZXJz
aW5nIGZpbGVzeXN0ZW0gLi4uCmVudHJ5ICJ0ZGIiIGluIHNob3J0Zm9ybSBkaXJlY3RvcnkgaW5v
ZGUgNzc5IHBvaW50cyB0byBmcmVlIGlub2RlIDc2NAp3b3VsZCBqdW5rIGVudHJ5CmVudHJ5ICIw
IiBpbiBzaG9ydGZvcm0gZGlyZWN0b3J5IGlub2RlIDI2ODQ0ODY3NiBwb2ludHMgdG8gZnJlZSBp
bm9kZSAyNjg0NDg2NzQKd291bGQganVuayBlbnRyeQogICAgICAgIC0gdHJhdmVyc2FsIGZpbmlz
aGVkIC4uLgogICAgICAgIC0gbW92aW5nIGRpc2Nvbm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtmb3Vu
ZCAuLi4KUGhhc2UgNyAtIHZlcmlmeSBsaW5rIGNvdW50cy4uLgpObyBtb2RpZnkgZmxhZyBzZXQs
IHNraXBwaW5nIGZpbGVzeXN0ZW0gZmx1c2ggYW5kIGV4aXRpbmcuCg==

--=__PartB189F112.1__=--
