Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 171667F4E
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 07:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 059A1304043
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 05:05:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1BjeCi1MDnCNXKLJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2015 05:05:03 -0700 (PDT)
Date: Thu, 12 Mar 2015 08:04:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Doubt about allocation of extents
Message-ID: <20150312120453.GB2463@laptop.bfoster>
References: <BLU169-W94914B167C788ACAB92562E1060@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU169-W94914B167C788ACAB92562E1060@phx.gbl>
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
To: Dhruvesh Rathore <dhruvesh_r@hotmail.com>
Cc: "sandeen@sandeen.net" <sandeen@sandeen.net>, "hch@lst.de" <hch@lst.de>, xfs@oss.sgi.com

(cc xfs)

On Thu, Mar 12, 2015 at 02:03:25AM +0000, Dhruvesh Rathore wrote:
> Hi,
> I have a question about allocation of existing extents to another file, and whetherit is possible ?
> A recently created file (temp) can have new extents created using lseek64()and the XFS_IOC_RESVP64.These empty extents can be populated by copying the data blocks from another file.(The above is mostly done in xfs_fsr, the online defragmenter of XFS).
> My question is that can i assign an existing populated extent held by another file, to thisnewly created temp file ?
> Any suggestions for the same will be appreciated :)

I think what you're describing is a clone or reflink type operation that
allows extents to be referenced by multiple files at once (e.g., writes
break the references via cow, etc.). Either that, or an extent move
operation that IIUC is something that extN supports. I suspect the
latter is more what you want if the target is defrag. XFS does not
support either at this time, though I think Dave is designing something
that might facilitate reflink down the road.

The only related operation I'm aware of for XFS right now is the swap
extents operation, which swaps the extents between two inodes. xfs_fsr
uses this along with a data copy to defragment files.

Brian

> Regards,Dhruvesh  		 	   		  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
