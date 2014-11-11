Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C43907F91
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 17:35:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1C0130405F
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:35:40 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id DZIuYRaEWZaSPYSS
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:35:38 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Enforcing quota for root user
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141111223203.GS28565@dastard>
Date: Tue, 11 Nov 2014 16:35:31 -0700
Message-Id: <256C65FE-C757-4457-9F68-1F35FE37968D@colorremedies.com>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
	<631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
	<20141111223203.GS28565@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3250713185404543070=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============3250713185404543070==
Content-Type: multipart/alternative; boundary="Apple-Mail=_1EF38950-0514-478B-A301-1D9C74871092"


--Apple-Mail=_1EF38950-0514-478B-A301-1D9C74871092
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Nov 11, 2014, at 3:32 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Nov 11, 2014 at 11:00:25AM -0700, Chris Murphy wrote:
>>=20
>> On Nov 11, 2014, at 8:36 AM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
>>=20
>>> On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
>>>> That's what I've read first, but someone showed me a sample where =
it works. He just told me he was using project quota. However, does it =
make sense ?=20
>>>> I've also read somewhere else that quota is never enforced for root =
user (id,gid=3D0) that's why I was testing it ....
>>>=20
>>> No, it doesn't make sense.  Why would you want to enforce quotas for =
root?
>>=20
>> A week ago I tried this and project quotas appear to apply to root.
>=20
> By intent and design. Project quotas are not a user/group based
> quota and so there is no exemption for any user.

It=92s what I=92d expect. I considered the documentation to be slightly =
misleading where is says soft and hard limits are never applied to the =
root user. The project quota does have a soft and hard limit. The soft =
limit, seemed not to apply to the root user - at least there was no soft =
limit warning anywhere when it was busted. But the hard limit definitely =
applied.

=
http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch08s04.=
html


>=20
>> [root@localhost project_quota_test1]# xfs_quota -c df
>> Filesystem           1K-blocks       Used  Available  Use% Pathname
>> /dev/sdb              83845120     157980   83687140    0% /xfs_local
>> /dev/sdb                102400     124928 9223372036854753280  122% =
/xfs_local/project_quota_test1
>> [root@localhost project_quota_test1]# dd if=3D/dev/zero of=3Dtest100MB =
bs=3D1M count=3D100
>> dd: error writing =91test100MB=92: No space left on device
>> 79+0 records in
>> 78+0 records out
>> 81788928 bytes (82 MB) copied, 0.163849 s, 499 MB/s
>> [root@localhost project_quota_test1]# xfs_quota -c df
>> Filesystem           1K-blocks       Used  Available  Use% Pathname
>> /dev/sdb              83845120     237748   83607372    0% /xfs_local
>> /dev/sdb                102400     204800 9223372036854673408  200% =
/xfs_local/project_quota_test1
>=20
> It's gone negative. That number in hex: 0x7FFFFFFFFFFE7000
>=20
> What kernel are you using, and can you outline all the way you set
> everything up to cause that to occur? Also, what is the output of a
> plain 'df -h' when it is in that state?

No that VM is gone so I can=92t check it, I=92d have to redo the test. =
Since at the time I was also testing Btrfs stuff I=92m going to say it =
was at the oldest 3.17.1, and could have been 3.18rc1 or rc2.


Chris Murphy=

--Apple-Mail=_1EF38950-0514-478B-A301-1D9C74871092
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;"><br><div><div>On Nov 11, 2014, at 3:32 PM, Dave =
Chinner &lt;<a =
href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt; =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite">On Tue, Nov 11, 2014 at 11:00:25AM -0700, Chris Murphy =
wrote:<br><blockquote type=3D"cite"><br>On Nov 11, 2014, at 8:36 AM, =
Stan Hoeppner &lt;<a =
href=3D"mailto:stan@hardwarefreak.com">stan@hardwarefreak.com</a>&gt; =
wrote:<br><br><blockquote type=3D"cite">On 11/11/2014 04:22 AM, Cyril =
Scetbon wrote:<br><blockquote type=3D"cite">That's what I've read first, =
but someone showed me a sample where it works. He just told me he was =
using project quota. However, does it make sense ? <br>I've also read =
somewhere else that quota is never enforced for root user (id,gid=3D0) =
that's why I was testing it ....<br></blockquote><br>No, it doesn't make =
sense. &nbsp;Why would you want to enforce quotas for =
root?<br></blockquote><br>A week ago I tried this and project quotas =
appear to apply to root.<br></blockquote><br>By intent and design. =
Project quotas are not a user/group based<br>quota and so there is no =
exemption for any user.<br></blockquote><div><br></div>It=92s what I=92d =
expect. I considered the documentation to be slightly misleading where =
is says soft and hard limits are never applied to the root user. The =
project quota does have a soft and hard limit. The soft limit, seemed =
not to apply to the root user - at least there was no soft limit warning =
anywhere when it was busted. But the hard limit definitely =
applied.</div><div><br></div><div><a =
href=3D"http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/=
ch08s04.html">http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US=
/html/ch08s04.html</a></div><div><br></div><div><br><blockquote =
type=3D"cite"><br><blockquote type=3D"cite">[root@localhost =
project_quota_test1]# xfs_quota -c df<br>Filesystem =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1K-blocks =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Used &nbsp;Available &nbsp;Use% =
Pathname<br>/dev/sdb =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;83845120 &nbsp;&nbsp;&nbsp;&nbsp;157980 &nbsp;&nbsp;83687140 =
&nbsp;&nbsp;&nbsp;0% /xfs_local<br>/dev/sdb =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;102400 &nbsp;&nbsp;&nbsp;&nbsp;124928 =
9223372036854753280 &nbsp;122% =
/xfs_local/project_quota_test1<br>[root@localhost project_quota_test1]# =
dd if=3D/dev/zero of=3Dtest100MB bs=3D1M count=3D100<br>dd: error =
writing =91test100MB=92: No space left on device<br>79+0 records =
in<br>78+0 records out<br>81788928 bytes (82 MB) copied, 0.163849 s, 499 =
MB/s<br>[root@localhost project_quota_test1]# xfs_quota -c =
df<br>Filesystem =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1K-blocks =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Used &nbsp;Available &nbsp;Use% =
Pathname<br>/dev/sdb =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;83845120 &nbsp;&nbsp;&nbsp;&nbsp;237748 &nbsp;&nbsp;83607372 =
&nbsp;&nbsp;&nbsp;0% /xfs_local<br>/dev/sdb =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;102400 &nbsp;&nbsp;&nbsp;&nbsp;204800 =
9223372036854673408 &nbsp;200% =
/xfs_local/project_quota_test1<br></blockquote><br>It's gone negative. =
That number in hex: 0x7FFFFFFFFFFE7000<br><br>What kernel are you using, =
and can you outline all the way you set<br>everything up to cause that =
to occur? Also, what is the output of a<br>plain 'df -h' when it is in =
that state?</blockquote><br></div><div>No that VM is gone so I can=92t =
check it, I=92d have to redo the test. Since at the time I was also =
testing Btrfs stuff I=92m going to say it was at the oldest 3.17.1, and =
could have been 3.18rc1 or =
rc2.</div><div><br></div><div><br></div><div>Chris =
Murphy</div></body></html>=

--Apple-Mail=_1EF38950-0514-478B-A301-1D9C74871092--


--===============3250713185404543070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3250713185404543070==--
