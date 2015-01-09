Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 322CE7F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 04:05:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 127068F8050
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 02:05:57 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id WLfNUIvoCAOi61d7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 02:05:53 -0800 (PST)
Date: Fri, 9 Jan 2015 11:05:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150109100551.GA23173@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
	<20150108164851.03b64e16@synchrony.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108164851.03b64e16@synchrony.poochiereds.net>
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
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 04:48:51PM -0800, Jeff Layton wrote:
> > +	nfsd4_return_all_file_layouts(stp->st_stateowner->so_client,
> > +				      stp->st_stid.sc_file);
> > +
> 
> Shouldn't the above be conditional on whether the lg_roc was true?

There is no support for non-lg_roc layouts at the moment.

In general I've avoided adding code that isn't used, as they can't
be tested and thus most likely won't work.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
