Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MKo9VF083446 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:50:09 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8BEA934FF
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:51:03 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 0P0uD4Phy8eJzoXI for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:51:03 -0700 (PDT)
Date: Wed, 22 Sep 2010 22:50:52 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Contiguous file sequences
Message-ID: <20100922205052.GA32059@citd.de>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
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
To: Daire Byrne <daire.byrne@gmail.com>
Cc: xfs@oss.sgi.com

On 22.09.2010 12:01, Daire Byrne wrote:
> Hi,

....


There is actually a VERY easy solution nowadays. SSD(s)

It doesn't matter if files are continuous or not, SSDs don't care (at 
least the better ones)

If you care about "worst case" write performance, zap the whole thing 
before usage (a.k.a.: trim) and write in chunks that are sized and 
aligned to erase-blocks (or just write in big chunks like 1MB or more). 
That should be more or less be enough to prevent latency spikes, that 
CAN plague SSDs.

What exactly you need obviously depends on the usual factors:
Needed sustained read/write bandwith, size, money, etc. etc.





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
