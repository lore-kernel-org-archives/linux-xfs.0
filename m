Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HHXvaE068391 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 12:33:58 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aRm4E2RiNWe3Cv2o (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 10:33:51 -0700 (PDT)
Date: Fri, 17 Aug 2012 13:33:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] Make inode64 a remountable option
Message-ID: <20120817173346.GA18347@infradead.org>
References: <1345171178-10447-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345171178-10447-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 16, 2012 at 11:39:38PM -0300, Carlos Maiolino wrote:
> +		case Opt_inode64:
> +
> +			for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> +				struct xfs_perag	*pag;
> +
> +				pag = xfs_perag_get(mp, i);
> +				pag->pagi_inodeok = 1;
> +				pag->pagf_metadata = 0;
> +				xfs_perag_put(pag);
> +			}
> +			mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> +					 XFS_MOUNT_SMALL_INUMS);
> +			mp->m_maxagi = i;

Can you factor this into a little helper?  I hate having lots of code
and especially loops inside of deep switch statements.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
