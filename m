Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RAiJmE162639 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 04:44:19 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yIINvLAM8c2ldNkx (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 02:44:14 -0800 (PST)
Date: Fri, 27 Jan 2012 05:44:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Insane file system overhead on large volume
Message-ID: <20120127104413.GA12347@infradead.org>
References: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
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
To: Manny <dermaniac@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 27, 2012 at 08:50:38AM +0100, Manny wrote:
> Hi there,
> 
> I'm not sure if this is intended behavior, but I was a bit stumped
> when I formatted a 30TB volume (12x3TB minus 2x3TB for parity in RAID
> 6) with XFS and noticed that there were only 22 TB left. I just called
> mkfs.xfs with default parameters - except for swith and sunit which
> match the RAID setup.
> 
> Is it normal that I lost 8TB just for the file system? That's almost
> 30% of the volume. Should I set the block size higher? Or should I
> increase the number of allocation groups? Would that make a
> difference? Whats the preferred method for handling such large
> volumes?

Where did you get the sizes for the raw volume and the filesystem usage
from?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
