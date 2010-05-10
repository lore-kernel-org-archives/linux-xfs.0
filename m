Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AI9Zxa020179 for <xfs@oss.sgi.com>; Mon, 10 May 2010 13:09:35 -0500
Received: from n5-vm0.bullet.mail.gq1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 18C67330D75
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 11:11:47 -0700 (PDT)
Received: from n5-vm0.bullet.mail.gq1.yahoo.com
	(n5-vm0.bullet.mail.gq1.yahoo.com [67.195.8.62]) by
	cuda.sgi.com with SMTP id Iyb6r7BNowDbLihJ for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 11:11:47 -0700 (PDT)
Message-ID: <978493.86662.qm@web112902.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
Date: Mon, 10 May 2010 11:11:45 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: bad primary superblock - bad magic number !!!
In-Reply-To: <4BE82955.2080009@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7485870078111747398=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============7485870078111747398==
Content-Type: multipart/alternative; boundary="0-419575489-1273515105=:86662"

--0-419575489-1273515105=:86662
Content-Type: text/plain; charset=us-ascii

Many Thanks.

I agree. I destroy and re-create raid and everything would show up GOOD, only for it to break again.
So was wondering whether those traces would point to anything.... my prime suspect is hard drives, but those xfs msgs confused me. 
Apologies for posting before carrying put more tests.

Thanks,
leo




________________________________
From: Eric Sandeen <sandeen@sandeen.net>
To: stress_buster <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com
Sent: Mon, May 10, 2010 4:42:13 PM
Subject: Re: bad primary superblock - bad magic number !!!

stress_buster wrote:
> my hp proliant DL185 server hangs/crashes and sometimes do not boot
> correctly...
> 
> [root@localhost dev]# xfs_repair -n /dev/cciss/c0d0p1
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...
> .....................................................................................Sorry,
> could not find valid secondary superblock
> Exiting now.
> 
> [root@localhost dev]# xfs_repair -n /dev/cciss/c0d2
> Phase 1 - find and verify superblock...
> superblock read failed, offset 0, size 524288, ag 0, rval -1
> 
> fatal error -- Input/output error
> 
> 
> [root@localhost dev]# xfs_db /dev/cciss/c0d0p1
> xfs_db: /dev/cciss/c0d0p1 is not a valid XFS filesystem (unexpected SB magic
> number 0x00000000)
> 
> The next time, server didnt even boot up alright
> 
> i've managed to capture the msgs & traces dumped to console. See below
> 
> 
> end_request: I/O error, dev cciss/c0d2, sector 0
> end_request: I/O error, dev cciss/c0d2, sector 0
> end_request: I/O error, dev cciss/c0d2, sector 1
> Quote:
> ciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
> end_request: I/O error, dev cciss/c0d3, sector 0
> cciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
> end_request: I/O error, dev cciss/c0d3, sector 0

You seem to have serious storage problems that are not XFS related.

You'll need to get that resolved.

-Eric



      
--0-419575489-1273515105=:86662
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><DIV>Many Thanks.</DIV>
<DIV>&nbsp;</DIV>
<DIV>I agree. I destroy and re-create raid and everything would show up GOOD, only for it to break again.</DIV>
<DIV>So was wondering whether those traces would point to anything.... my prime suspect is hard drives, but those xfs msgs confused me. </DIV>
<DIV>Apologies for posting before carrying put more tests.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>leo<BR></DIV>
<DIV style="FONT-FAMILY: times new roman, new york, times, serif; FONT-SIZE: 12pt"><BR>
<DIV style="FONT-FAMILY: arial, helvetica, sans-serif; FONT-SIZE: 13px"><FONT size=2 face=Tahoma>
<HR SIZE=1>
<B><SPAN style="FONT-WEIGHT: bold">From:</SPAN></B> Eric Sandeen &lt;sandeen@sandeen.net&gt;<BR><B><SPAN style="FONT-WEIGHT: bold">To:</SPAN></B> stress_buster &lt;leo1783@yahoo.com&gt;<BR><B><SPAN style="FONT-WEIGHT: bold">Cc:</SPAN></B> xfs@oss.sgi.com<BR><B><SPAN style="FONT-WEIGHT: bold">Sent:</SPAN></B> Mon, May 10, 2010 4:42:13 PM<BR><B><SPAN style="FONT-WEIGHT: bold">Subject:</SPAN></B> Re: bad primary superblock - bad magic number !!!<BR></FONT><BR>stress_buster wrote:<BR>&gt; my hp proliant DL185 server hangs/crashes and sometimes do not boot<BR>&gt; correctly...<BR>&gt; <BR>&gt; [root@localhost dev]# xfs_repair -n /dev/cciss/c0d0p1<BR>&gt; Phase 1 - find and verify superblock...<BR>&gt; bad primary superblock - bad magic number !!!<BR>&gt; <BR>&gt; attempting to find secondary superblock...<BR>&gt; .....................................................................................Sorry,<BR>&gt; could not find valid secondary
 superblock<BR>&gt; Exiting now.<BR>&gt; <BR>&gt; [root@localhost dev]# xfs_repair -n /dev/cciss/c0d2<BR>&gt; Phase 1 - find and verify superblock...<BR>&gt; superblock read failed, offset 0, size 524288, ag 0, rval -1<BR>&gt; <BR>&gt; fatal error -- Input/output error<BR>&gt; <BR>&gt; <BR>&gt; [root@localhost dev]# xfs_db /dev/cciss/c0d0p1<BR>&gt; xfs_db: /dev/cciss/c0d0p1 is not a valid XFS filesystem (unexpected SB magic<BR>&gt; number 0x00000000)<BR>&gt; <BR>&gt; The next time, server didnt even boot up alright<BR>&gt; <BR>&gt; i've managed to capture the msgs &amp; traces dumped to console. See below<BR>&gt; <BR>&gt; <BR>&gt; end_request: I/O error, dev cciss/c0d2, sector 0<BR>&gt; end_request: I/O error, dev cciss/c0d2, sector 0<BR>&gt; end_request: I/O error, dev cciss/c0d2, sector 1<BR>&gt; Quote:<BR>&gt; ciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4<BR>&gt; end_request: I/O error, dev cciss/c0d3, sector 0<BR>&gt; cciss: cmd f6c00000 has
 CHECK CONDITION sense key = 0x4<BR>&gt; end_request: I/O error, dev cciss/c0d3, sector 0<BR><BR>You seem to have serious storage problems that are not XFS related.<BR><BR>You'll need to get that resolved.<BR><BR>-Eric<BR></DIV></DIV></div><br>







      </body></html>
--0-419575489-1273515105=:86662--


--===============7485870078111747398==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7485870078111747398==--
