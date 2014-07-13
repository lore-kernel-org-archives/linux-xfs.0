Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBE1B7F73
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 20:48:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3386304032
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 18:48:54 -0700 (PDT)
Received: from mail-qc0-f175.google.com (mail-qc0-f175.google.com
	[209.85.216.175]) by cuda.sgi.com with ESMTP id
	7mOFRVKqNHrkYnG0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Jul 2014 18:48:53 -0700 (PDT)
Received: by mail-qc0-f175.google.com with SMTP id i8so2347394qcq.34
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 18:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140713012624.GS4453@dastard>
References: <CA+4uBUYg+81G2=sj3qXO4GGgA7pyjgVrGDCN+UQ32jnWgSbG5w@mail.gmail.com>
	<20140713012624.GS4453@dastard>
Date: Sat, 12 Jul 2014 18:48:52 -0700
Message-ID: <CA+4uBUZwuh5t28jU5jfQb3ApdUKx8t88hg6m8CXS+0ztpi6OTw@mail.gmail.com>
Subject: Re: consequences of XFS_IOC_FSSETXATTR on non-empty file?
From: Samuel Just <sam.just@inktank.com>
Content-Type: multipart/mixed; boundary=047d7bdca91e6acdc904fe096079
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>, xfs@oss.sgi.com

--047d7bdca91e6acdc904fe096079
Content-Type: text/plain; charset=UTF-8

Actually, on this ubuntu kernel (3.13.0-24-generic), it doesn't seem
to give an error.  I'll attach my test case for that.  We don't yet
have a way of reproducing the corruption -- the ext_size change in the
osd simply seemed like a promising lead.
-Sam

On Sat, Jul 12, 2014 at 6:26 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jul 12, 2014 at 06:16:54PM -0700, Samuel Just wrote:
>> Hi,
>>
>> We are seeing reports of ceph-osd stores on xfs of files with some
>> garbage data (possibly misplaced from data elsewhere in the
>> filesystem).  There was a bug for a while where the ceph-osd process
>> would set a value for fsx_extsize on a non-empty (possibly sparse)
>> file using XFS_IOC_FSSETXATTR.  Could that plausibly result in a file
>> with garbage data?
>
> No, setting an extent size on a non-empty file will simply fail
> with EINVAL.
>
> Do you have any method of reproducing the bad data in files?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

--047d7bdca91e6acdc904fe096079
Content-Type: text/x-c++src; charset=US-ASCII; name="xfs_extsize_test.cc"
Content-Disposition: attachment; filename="xfs_extsize_test.cc"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxjpc6z90

LyoqCiAqIFRyeSBjaGFuZ2luZyBleHRzaXplIG9uIGEgbm9uLWVtcHR5IHNwYXJzZSBvYmplY3QK
ICovCgojaW5jbHVkZSA8eGZzL3hmcy5oPgojaW5jbHVkZSA8Y3N0ZGlvPgojaW5jbHVkZSA8dW5p
c3RkLmg+CiNpbmNsdWRlIDxpb3N0cmVhbT4KI2luY2x1ZGUgPHN0cmluZy5oPgoKaW50IG1haW4o
KSB7CiAgY2hhciBidWZbMjU2XTsKICBtZW1zZXQoYnVmLCAxLCBzaXplb2YoYnVmKSk7CgogIGlu
dCBmZCA9IG9wZW4oInRlc3QiLCBPX1JEV1J8T19DUkVBVHxPX0VYQ0wsIDA2NjYpOwogIGFzc2Vy
dChmZCA+PSAwKTsKCiAgaW50IHIgPSBwd3JpdGUoZmQsIGJ1ZiwgMSwgMjQ8PDEwKTsKICBhc3Nl
cnQociA9PSAxKTsKCiAgY2xvc2UoZmQpOwoKICBmZCA9IG9wZW4oInRlc3QiLCBPX1JEV1IpOwog
IGFzc2VydChmZCA+PSAwKTsKCiAgc3RydWN0IGZzeGF0dHIgZnN4OwogIHIgPSBpb2N0bChmZCwg
WEZTX0lPQ19GU0dFVFhBVFRSLCAmZnN4KTsKICBpZiAociA8IDApIHsKICAgIGludCByZXQgPSAt
ZXJybm87CiAgICBzdGQ6OmNlcnIgPDwgIkZTR0VUWEFUVFI6ICIgPDwgcmV0IDw8IHN0ZDo6ZW5k
bDsKICAgIHJldHVybiByZXQ7CiAgfQoKICAvLyBhbHJlYWR5IHNldD8KICBpZiAoZnN4LmZzeF94
ZmxhZ3MgJiBYRlNfWEZMQUdfRVhUU0laRSkgewogICAgc3RkOjpjZXJyIDw8ICJhbHJlYWR5IHNl
dCIgPDwgc3RkOjplbmRsOwogICAgcmV0dXJuIDA7CiAgfQoKICBzdGQ6OmNlcnIgPDwgZnN4LmZz
eF9uZXh0ZW50cyA8PCAiIGV4ZW50cywgZXh0c2l6ZSBpcyAiIDw8IGZzeC5mc3hfZXh0c2l6ZSA8
PCBzdGQ6OmVuZGw7CgogIHVuc2lnbmVkIHZhbCA9IDQ8PDIwOwogIGZzeC5mc3hfeGZsYWdzIHw9
IFhGU19YRkxBR19FWFRTSVpFOwogIGZzeC5mc3hfZXh0c2l6ZSA9IHZhbDsKICAKICBpZiAoaW9j
dGwoZmQsIFhGU19JT0NfRlNTRVRYQVRUUiwgJmZzeCkgPCAwKSB7CiAgICBpbnQgcmV0ID0gLWVy
cm5vOwogICAgc3RkOjpjZXJyIDw8ICJGU1NFVFhBVFRSOiAiIDw8IHJldCA8PCBzdGQ6OmVuZGw7
CiAgICByZXR1cm4gcmV0OwogIH0KCiAgc3RydWN0IGZzeGF0dHIgZnN4MjsKICByID0gaW9jdGwo
ZmQsIFhGU19JT0NfRlNHRVRYQVRUUiwgJmZzeDIpOwogIGlmIChyIDwgMCkgewogICAgaW50IHJl
dCA9IC1lcnJubzsKICAgIHN0ZDo6Y2VyciA8PCAiRlNHRVRYQVRUUjogIiA8PCByZXQgPDwgc3Rk
OjplbmRsOwogICAgcmV0dXJuIHJldDsKICB9CgogIGlmIChmc3gyLmZzeF94ZmxhZ3MgJiBYRlNf
WEZMQUdfRVhUU0laRSkgewogICAgc3RkOjpjZXJyIDw8ICJzdWNjZXNzZnVsbHkgc2V0IHRvICIg
PDwgZnN4Mi5mc3hfZXh0c2l6ZSA8PCBzdGQ6OmVuZGw7CiAgfQoKICBjbG9zZShmZCk7CgojaWYg
MAogIGZkID0gb3BlbigidGVzdCIsIE9fUkRPTkxZKTsKICBhc3NlcnQoZmQgPj0gMCk7CgogIGNo
YXIgemJ1ZlsyNDw8MTBdOwogIG1lbXNldCh6YnVmLCAwLCBzaXplb2YoemJ1ZikpOwogIGNoYXIg
b2J1ZlsyNDw8MTBdOwogIHIgPSByZWFkKGZkLCBvYnVmLCBzaXplb2Yob2J1ZikpOwogIGFzc2Vy
dChyID09IHNpemVvZihvYnVmKSk7CgogIHIgPSBtZW1jbXAoemJ1Ziwgb2J1Ziwgc2l6ZW9mKHpi
dWYpKTsKICBhc3NlcnQociA9PSAwKTsKICBjbG9zZShmZCk7CiNlbmRpZgp9Cg==
--047d7bdca91e6acdc904fe096079
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--047d7bdca91e6acdc904fe096079--
