Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C02437F3F
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 21:46:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 851528F8035
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 19:46:20 -0800 (PST)
Received: from mail-oa0-f54.google.com (mail-oa0-f54.google.com
	[209.85.219.54]) by cuda.sgi.com with ESMTP id Oo4VYNSlNayHg8KC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Dec 2013 19:46:19 -0800 (PST)
Received: by mail-oa0-f54.google.com with SMTP id h16so17856193oag.13
	for <xfs@oss.sgi.com>; Wed, 04 Dec 2013 19:46:18 -0800 (PST)
In-Reply-To: <20131205034034.GI8803@dastard>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<20131205034034.GI8803@dastard>
MIME-Version: 1.0
Subject: Re: Sudden File System Corruption
From: Mike Dacre <mike.dacre@gmail.com>
Date: Wed, 04 Dec 2013 19:46:06 -0800
Message-ID: <1423a84e-a9e3-4053-bb7c-fdf2d53eeefc@email.android.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2143545157152828607=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2143545157152828607==
Content-Type: multipart/alternative; boundary="----IFIWK4ZGAGQYSQXY2J8DDWDA2Y6P2A"

------IFIWK4ZGAGQYSQXY2J8DDWDA2Y6P2A
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Dave, 

My apologies, I completely miscommunicated.  The drive dying was unrelated, it happened two months ago. I mentioned it only as background info, but I realize now that was stupid. There were no drive or RAID problems at all at the time the XFS mount died today. The drives are all fine and the RAID log shows nothing significant. 

Thanks, 

Mike 


-------- Original Message --------
From: Dave Chinner <david@fromorbit.com>
Sent: Wed Dec 04 19:40:34 PST 2013
To: Mike Dacre <mike.dacre@gmail.com>
Cc: xfs@oss.sgi.com
Subject: Re: Sudden File System Corruption

On Wed, Dec 04, 2013 at 06:55:05PM -0800, Mike Dacre wrote:
> Hi Folks,
> 
> Apologies if this is the wrong place to post or if this has been answered
> already.
> 
> I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an XFS
> filesystem and has been online for over a year.  It is accessed by 23
> different machines connected via Infiniband over NFS v3.  I haven't had any
> major problems yet, one drive failed but it was easily replaced.
> 
> However, today the drive suddenly stopped responding and started returning
> IO errors when any requests were made.  This happened while it was being
> accessed by  5 different users, one was doing a very large rm operation (rm
> *sh on thousands on files in a directory).  Also, about 30 minutes before
> we had connected the globus connect endpoint to allow easy file transfers
> to SDSC.

So, you had a drive die and at roughly the same time XFS started
reporting corruption problems and shut down? Chances are that the
drive returned garbage to XFS before died completely and that's what
XFS detected and shut down on. If you are unlucky in this situation,
the corruption can get propagated into the log by changes that are
adjacent to the corrupted region, and then you have problems with log
recovery failing because the corruption gets replayed....

> I have attached the complete log from the time it died until now.
> 
> In the end, I successfully repaired the filesystem with `xfs_repair -L
> /dev/sda1`.  However, I am nervous that some files may have been corrupted.
> 
> Do any of you have any idea what could have caused this problem?

When corruption appears at roughly the same time a drive dies, it's
almost always caused by the drive that failed. RAID doesn't repvent
disks from returning crap to the OS because nobody configures the
arrays to do read-verify cycles that would catch such a condition.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

------IFIWK4ZGAGQYSQXY2J8DDWDA2Y6P2A
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>Hi Dave, <br>
<br>
My apologies, I completely miscommunicated.  The drive dying was unrelated, it happened two months ago. I mentioned it only as background info, but I realize now that was stupid. There were no drive or RAID problems at all at the time the XFS mount died today. The drives are all fine and the RAID log shows nothing significant. <br>
<br>
Thanks, <br>
<br>
Mike <br><br><div style='font-size:10.0pt;font-family:"Tahoma","sans-serif";padding:3.0pt 0in 0in 0in'>
<hr style='border:none;border-top:solid #E1E1E1 1.0pt'>
<b>From:</b> Dave Chinner &lt;david@fromorbit.com&gt;<br>
<b>Sent:</b> Wed Dec 04 19:40:34 PST 2013<br>
<b>To:</b> Mike Dacre &lt;mike.dacre@gmail.com&gt;<br>
<b>Cc:</b> xfs@oss.sgi.com<br>
<b>Subject:</b> Re: Sudden File System Corruption<br>
</div>
<br>
<pre class="k9mail">On Wed, Dec 04, 2013 at 06:55:05PM -0800, Mike Dacre wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> Hi Folks,<br /> <br /> Apologies if this is the wrong place to post or if this has been answered<br /> already.<br /> <br /> I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an XFS<br /> filesystem and has been online for over a year.  It is accessed by 23<br /> different machines connected via Infiniband over NFS v3.  I haven't had any<br /> major problems yet, one drive failed but it was easily replaced.<br /> <br /> However, today the drive suddenly stopped responding and started returning<br /> IO errors when any requests were made.  This happened while it was being<br /> accessed by  5 different users, one was doing a very large rm operation (rm<br /> *sh on thousands on files in a directory).  Also, about 30 minutes before<br /> we had connected the 
 globus
connect endpoint to allow easy file transfers<br /> to SDSC.<br /></blockquote><br />So, you had a drive die and at roughly the same time XFS started<br />reporting corruption problems and shut down? Chances are that the<br />drive returned garbage to XFS before died completely and that's what<br />XFS detected and shut down on. If you are unlucky in this situation,<br />the corruption can get propagated into the log by changes that are<br />adjacent to the corrupted region, and then you have problems with log<br />recovery failing because the corruption gets replayed....<br /><br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> I have attached the complete log from the time it died until now.<br /> <br /> In the end, I successfully repaired the filesystem with `xfs_repair -L<br /> /dev/sda1`.  However, I am nervous that some files may have been corrupted.<br /> <br /> Do any of you have any idea what cou
 ld have
caused this problem?<br /></blockquote><br />When corruption appears at roughly the same time a drive dies, it's<br />almost always caused by the drive that failed. RAID doesn't repvent<br />disks from returning crap to the OS because nobody configures the<br />arrays to do read-verify cycles that would catch such a condition.<br /><br />Cheers,<br /><br />Dave.</pre></body></html>
------IFIWK4ZGAGQYSQXY2J8DDWDA2Y6P2A--


--===============2143545157152828607==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2143545157152828607==--
