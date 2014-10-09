Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C342C7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 10:19:56 -0500 (CDT)
Date: Thu, 9 Oct 2014 10:19:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/16] xfs: implement demand load of utf8norm.ko
Message-ID: <20141009151956.GA1865@sgi.com>
References: <20141003214758.GY1865@sgi.com> <20141003220357.GM1865@sgi.com>
	<20141004071651.GB5168@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141004071651.GB5168@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Sat, Oct 04, 2014 at 12:16:51AM -0700, Christoph Hellwig wrote:
> > +int
> > +xfs_init_utf8_module(struct xfs_mount	*mp)
> > +{
> > +	request_module("utf8norm");
> > +
> > +	spin_lock(&utf8norm_lock);
> > +	if (utf8norm_initialized) {
> > +		spin_unlock(&utf8norm_lock);
> > +		return 0;
> > +	}
> > +
> > +	utf8version_is_supported_func = symbol_get(utf8version_is_supported);
> > +	if (!utf8version_is_supported_func)
> > +		goto error;
> > +
> > +	utf8nfkdi_func = symbol_get(utf8nfkdi);
> > +	if (!utf8nfkdi_func)
> > +		goto error;
> 
> Please export a structure with a function pointes so that we just need
> a single symbol_get call.  I'd have to look up how symbol_get works,
> but unless there's something that speaks against this it might be
> simpler to than just do a symbol_get per mounst structure that uses
> utf8 and can point to that structure so that we don't have to add
> additional reference counting infrastructure around it.

Sure, sounds good.  I believe I've seen the approach you are suggesting
used elsewhere and it works fine.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
