Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D558E7F63
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 17:06:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C224D8F8033
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 15:06:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id QSMTWYfWMzzPRyUb
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 15:06:23 -0700 (PDT)
Message-ID: <5211455B.3000409@hardwarefreak.com>
Date: Sun, 18 Aug 2013 17:06:19 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS recovery resumes...
References: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 8/18/2013 4:38 PM, Jay Ashworth wrote:
> I'm trying to dedupe the two large XFS filesystems on which I have DVR 
> recordings, so that I can walk around amongst the available HDDs and create
> new filesystems under everything.
> 
> Every time I rm a file, the filesystem blows up, and the driver shuts it
> down.  
> 
> Some background:
> 
> At the moment, I have 2 devices, /dev/sdd1 mounted on /appl/media4, and
> /dev/sda1 mounted on /appl/media5, and a large script, created by hand-
> hacking the output of a perl dupe finder script.
> 
> The large script was mangled so that it would remove anything that was a 
> dupe from media4, unless the file was an unlabeled lost+found on media5,
> and had a name on media4.  In that case, I removed the file on media5, and
> then moved it from media4 to media5.
> 
> After the hand-hacking on the script, I sorted it to do all the rm's first,
> and then all the mv's, to make sure free space when up before it went down.
> 
> And, of course, when I ran the script, it caused the XFS driver to cough and
> die, leading to error 5s and gnashing of teeth.

If this script is the catalyst of your XFS problems, it seems logical
that you would include said script in your trouble report, yet you did
not.  It's a bit foolish to assume you can't break a Linux subsystem
with a poorly written program and/or in combination with a platform that
isn't up to the task being asked of it.  As Joe mentioned having too
little RAM could be part of this problem.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
