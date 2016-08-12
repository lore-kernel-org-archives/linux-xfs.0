Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 560607CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 21:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17229304043
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 19:57:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rR3Rm6L4VAxmQfVj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 19:57:54 -0700 (PDT)
Date: Thu, 11 Aug 2016 19:57:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
Message-ID: <20160812025753.GD10701@infradead.org>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<ea8cca9bf1dbeb13a788f85f73d6bafbcc374a89.1470555003.git.felix.janda@posteo.de>
	<20160809073611.GC25647@infradead.org> <20160809174105.GA5907@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809174105.GA5907@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 09, 2016 at 07:41:05PM +0200, Felix Janda wrote:
> Thanks for reviewing the patch series!
> 
> > Does this also error out for libraries that don't support large
> > off_t at all?  I think that would be helpful to add if not there yet.
> 
> I do not quite understand. Do you refer to libraries using libxfs or
> the external libraries used by xfsprogs?

I meant C libraries, sorry.  E.g. uclibc used to not support LFS
many years ago, although they probably fixed it up by now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
