Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD16wPs004496 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 19:06:58 -0600
Date: Mon, 12 Nov 2012 17:09:00 -0800
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 12/32] xfs: verify AGF blocks as they are read from disk
Message-ID: <20121113010900.GE27231@caliban.engr.sgi.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-13-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave, you botched a copy & paste here:

On Mon, Nov 12, 2012 at 10:54:04PM +1100, Dave Chinner wrote:
> +	agf_ok = agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
> +		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> +		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> +		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);

See: 
> -	agf_ok =
> -		agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
> -		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> -		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> -		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
> -		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
> -		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
> -		be32_to_cpu(agf->agf_seqno) == agno;

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
