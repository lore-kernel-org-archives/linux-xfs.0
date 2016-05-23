Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 736DB7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 09:52:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43DF78F8040
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 07:52:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZSABlnZ8UmetJB02 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 07:52:51 -0700 (PDT)
Date: Mon, 23 May 2016 07:52:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: allow recalculating CRCs on invalid metadata
Message-ID: <20160523145250.GF9319@infradead.org>
References: <1463092513-5462-1-git-send-email-david@fromorbit.com>
	<ee586739-e804-8174-8497-cc8a992b9752@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ee586739-e804-8174-8497-cc8a992b9752@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, May 12, 2016 at 06:03:15PM -0500, Eric Sandeen wrote:
> Using "TYP_NO_CRC_OFF" seems a little weird from a naming perspective;
> it's not really a  TYP_* is it?   Its opposite is things like
> XFS_AGI_CRC_OFF; NO_FIXED_CRC_OFF might be better to not confuse it
> with the TYP_ on-disk types?  Just a thought.

Agreed.  How about adding a _F inbetween, e.g. TYP_F_NO_CRC_OFF?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
