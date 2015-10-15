Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E7D37F50
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 09:42:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EEB28304066
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 07:42:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WYT2EQyY3r8B5Czj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Oct 2015 07:42:18 -0700 (PDT)
Date: Thu, 15 Oct 2015 07:41:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
Message-ID: <20151015144146.GL10391@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<20151007051323.3260.60421.stgit@birch.djwong.org>
	<20151015091944.GA13683@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151015091944.GA13683@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Thu, Oct 15, 2015 at 02:19:44AM -0700, Christoph Hellwig wrote:
> > +# this test requires the test fs support reflink...
> > +#
> > +_require_test_reflink()
> > +{
> > +    case $FSTYP in
> > +    xfs)
> > +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +	;;
> > +    btrfs)
> > +        true
> > +        ;;
> > +    *)
> > +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +        ;;
> > +    esac
> 
> I don't think that's a good test - we need to check if it's supported by
> trying it.  That'll automatically get us coverage for other file systems
> like xfs.
> 
> Note that dedup should get it's own feature check, as currently hacking
> nfs into this check will also run dedup tests that can't really be
> supported.

Good point.  I'll throw that in while I rework the tests.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
