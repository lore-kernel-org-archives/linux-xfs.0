Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55DED7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 18:47:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7501AC00C
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 16:47:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7BiqEtPmeJnTXDjT for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 16:47:16 -0700 (PDT)
Date: Tue, 14 Oct 2014 10:47:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Mount: Structure needs cleaning
Message-ID: <20141013234700.GF5267@dastard>
References: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
	<20141013220940.GE17506@dastard>
	<EC9978C1-65B4-48B8-9C3D-980341A752E8@me.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <EC9978C1-65B4-48B8-9C3D-980341A752E8@me.com>
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
To: Tom Mason <tom_mason@me.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Oct 13, 2014 at 11:38:34PM +0100, Tom Mason wrote:
> Btw - before I get rid of this old samsung 1tb drive, the folder's
> properties in the failed drive actually report a lot higher for
> file numbers and sizes than eventually get copied - it reports:
> "Error while copying There was an error getting information about
> the files in the folder 'xxxxx' no data available" ...is there a
> way around this or is this my lost data?

You're now into disaster recovery territory. Use ddrescue to image
the filesystem, then something like photorec or some other data
recovery tool to scrape the image for intact files that otherwise
couldn't be pulled from the mounted filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
