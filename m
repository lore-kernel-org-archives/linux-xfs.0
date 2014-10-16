Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 488207F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 00:22:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24BAB304051
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 22:22:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AZ359Btr6q0S19hY for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 22:22:37 -0700 (PDT)
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
	<543F3C9A.4060603@sandeen.net>
	<CAGdb-8fE+jh0dojaScF=3Oc4Ovea=Tvw1tnRxwb+iroaZd3i9g@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CAGdb-8fE+jh0dojaScF=3Oc4Ovea=Tvw1tnRxwb+iroaZd3i9g@mail.gmail.com>
Message-Id: <F2B1FDA1-8352-4D67-9873-9C069AC66E94@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfsdump not work in 3.17
Date: Thu, 16 Oct 2014 00:22:33 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5139997505613952985=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>


--===============5139997505613952985==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-BC441E3E-0509-426A-9DD7-C3EBF5C5EF18
Content-Transfer-Encoding: 7bit


--Apple-Mail-BC441E3E-0509-426A-9DD7-C3EBF5C5EF18
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

On Oct 15, 2014, at 11:14 PM, Tommy Wu <wu.tommy@gmail.com> wrote:
>=20
> after apply above patch,

Which one?  I pointed at 2... Did you apply both?

Eric

> the xfsdump will hang after this message:
>=20
> /sbin/xfsdump: dumping non-directory files
>=20
>=20
> 2014-10-16 11:33 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:
>> On 10/15/14 9:31 PM, Tommy Wu wrote:
>> > Hi!
>> >
>> >    xfsdump 3.1.4
>> >    xfsprogs 3.2.1
>> >    linux kerenl 3.17/3.17.1
>> >
>>=20
>> ...
>>=20
>> >    It just create  a small dump file, and if I run the same xfsdump aga=
in (or umount the filesystem), it will hang, like:
>> >
>> > fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=3Ddebug,media=3Ddebug=
 -l 0 -o -J -F - /dev/vg/root | gzip > test.gz
>> > /sbin/xfsdump: using file dump (drive_simple) strategy
>> > /sbin/xfsdump: version 3.1.4 (dump format 3.0)
>> > /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
>> > /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
>> > /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
>> > /sbin/xfsdump: session label: ""
>> > /sbin/xfsdump: ino map phase 1: constructing initial dump list
>> >
>> >
>> >    switch back to kernel 3.16, the same command work fine.
>> >
>>=20
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/=
xfs?id=3Da8b1ee8bafc765ebf029d03c5479a69aebff9693
>>=20
>> addresses the small backup file, and
>>=20
>> [PATCH] xfs: bulkstat doesn't release AGI buffer on error
>>=20
>> (on the list) most likely addresses the hang, I think.
>>=20
>> -Eric
>=20
>=20
>=20
> --=20
>=20
> Tommy Wu

--Apple-Mail-BC441E3E-0509-426A-9DD7-C3EBF5C5EF18
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head><body dir="auto"><div>On Oct 15, 2014, at 11:14 PM, Tommy Wu &lt;<a href="mailto:wu.tommy@gmail.com">wu.tommy@gmail.com</a>&gt; wrote:</div><div><br></div><blockquote type="cite"><div><div dir="ltr">after apply above patch, </div></div></blockquote><div><br></div>Which one? &nbsp;I pointed at 2... Did you apply both?<div><br></div><div>Eric</div><div><br><blockquote type="cite"><div><div dir="ltr">the xfsdump will hang after this message:<br><br>/sbin/xfsdump: dumping non-directory files<br><br></div><div class="gmail_extra"><br><div class="gmail_quote">2014-10-16 11:33 GMT+08:00 Eric Sandeen <span dir="ltr">&lt;<a href="mailto:sandeen@sandeen.net" target="_blank">sandeen@sandeen.net</a>&gt;</span>:<br><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class="">On 10/15/14 9:31 PM, Tommy Wu wrote:<br>
&gt; Hi!<br>
&gt;<br>
&gt;&nbsp; &nbsp; xfsdump 3.1.4<br>
&gt;&nbsp; &nbsp; xfsprogs 3.2.1<br>
&gt;&nbsp; &nbsp; linux kerenl 3.17/3.17.1<br>
&gt;<br>
<br>
</span>...<br>
<span class=""><br>
&gt;&nbsp; &nbsp; It just create&nbsp; a small dump file, and if I run the same xfsdump again (or umount the filesystem), it will hang, like:<br>
&gt;<br>
&gt; fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0 -o -J -F - /dev/vg/root | gzip &gt; test.gz<br>
&gt; /sbin/xfsdump: using file dump (drive_simple) strategy<br>
&gt; /sbin/xfsdump: version 3.1.4 (dump format 3.0)<br>
&gt; /sbin/xfsdump: level 0 dump of <a href="http://fw1.teatime.com.tw">fw1.teatime.com.tw</a>:/<br>
&gt; /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014<br>
&gt; /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208<br>
&gt; /sbin/xfsdump: session label: ""<br>
&gt; /sbin/xfsdump: ino map phase 1: constructing initial dump list<br>
&gt;<br>
&gt;<br>
&gt;&nbsp; &nbsp; switch back to kernel 3.16, the same command work fine.<br>
&gt;<br>
<br>
</span><a href="http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693" target="_blank">http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693</a><br>
<br>
addresses the small backup file, and<br>
<br>
[PATCH] xfs: bulkstat doesn't release AGI buffer on error<br>
<br>
(on the list) most likely addresses the hang, I think.<br>
<span class="HOEnZb"><font color="#888888"><br>
-Eric<br>
</font></span></blockquote></div><br><br clear="all"><br>-- <br><br>Tommy Wu
</div>
</div></blockquote></div></body></html>
--Apple-Mail-BC441E3E-0509-426A-9DD7-C3EBF5C5EF18--


--===============5139997505613952985==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5139997505613952985==--
