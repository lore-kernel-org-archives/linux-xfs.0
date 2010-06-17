Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5HBcFQp175000 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 06:38:18 -0500
Date: Thu, 17 Jun 2010 07:40:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Security] XFS swapext ioctl minor security issues
Message-ID: <20100617114051.GA13118@infradead.org>
References: <AANLkTilrwmh6n7yYkqyvy_y5-bgS-BEDept0WlLg5GE1@mail.gmail.com>
	<AANLkTikGFq8iv4S3QWp5ZCvXJsjuiP2tKweSl6QwHc6U@mail.gmail.com>
	<20100616121142.GA22317@infradead.org>
	<AANLkTimVtpQuRZpOJ4IGlFzRqWG6XaYGzvUnDuF06MyG@mail.gmail.com>
	<20100616133433.GA16437@infradead.org>
	<AANLkTimJHo3zfi0t96vVlTYgDswh8QtsptoTNkVK7Eb9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimJHo3zfi0t96vVlTYgDswh8QtsptoTNkVK7Eb9@mail.gmail.com>
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
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, security@kernel.org, xfs@oss.sgi.com, Eugene Teo <eugeneteo@kernel.sg>, aelder@sgi.com

On Wed, Jun 16, 2010 at 09:57:35AM -0400, Dan Rosenberg wrote:
> I removed the part of the patch dealing with suid/sgid bits - your
> reasoning seems good, we clearly don't want to just drop the suid/sgid
> bits. ?I was just trying to point out the case where the caller is not
> the owner and has write access to the file; since in the ordinary case
> writing to that file would result in dropping the suid bit, I thought
> this ioctl should try to replicate that behavior.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Alex, can you push it to Linus ASAP?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
