Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35LwAkQ077489 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 16:58:10 -0500
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id l31Q4A4T8VD6YNFJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 14:58:08 -0700 (PDT)
Date: Thu, 5 Apr 2012 23:57:55 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: How to pre-allocate files for sequential access?
Message-ID: <20120405215755.GA18725@citd.de>
References: <33564834.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33564834.post@talk.nabble.com>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

On 04.04.2012 16:57, troby wrote:

...

I think the easiest solution would be to create the said number of 
files, but with dummy-filenames.

Then write a script das does a xfs_bmap on each file, sorts them and 
then renames the dummy-files to the correct-name in the order they are 
on disc.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
