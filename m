Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35MeV0g082307 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 17:40:31 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id SUPYhwB0jE2syfJ0 for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 15:40:30 -0700 (PDT)
References: <33564834.post@talk.nabble.com> <20120405215755.GA18725@citd.de>
In-Reply-To: <20120405215755.GA18725@citd.de>
Mime-Version: 1.0 (1.0)
Message-Id: <FC3BFCA4-296E-4759-A168-1AC0BBE30D31@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: How to pre-allocate files for sequential access?
Date: Thu, 5 Apr 2012 15:40:22 -0700
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: troby <Thorn.Roby@harlandfs.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Apr 5, 2012, at 2:57 PM, Matthias Schniedermeyer <ms@citd.de> wrote:

> On 04.04.2012 16:57, troby wrote:
> 
> ...
> 
> I think the easiest solution would be to create the said number of 
> files, but with dummy-filenames.
> 
> Then write a script das does a xfs_bmap on each file, sorts them and 
> then renames the dummy-files to the correct-name in the order they are 
> on disc.
> 

Inode64 will likely keep them in order without needing tricks like that.

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
