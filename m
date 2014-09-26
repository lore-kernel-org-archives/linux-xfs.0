Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA6867FB3
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 11:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95E878F8049
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 09:56:08 -0700 (PDT)
Date: Fri, 26 Sep 2014 09:56:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140926165605.GA25274@infradead.org>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54257D3F.70302@sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 04:50:39PM +0200, Olaf Weber wrote:
> I'm not sure how common the parsing code can be if needs to be capable of
> retrieving data from a filesystem.
> 
> Note given your and Andi Kleen's feedback on the trie size I've switched to
> doing algorithmic decomposition for Hangul. This reduces the size of the
> trie to 89952 bytes.
> 
> In addition, if you store the trie in the filesystem, then the only part
> that needs storing is the version for that particular filesystem, e.g no
> compatibility info for different unicode versions would be required.  This
> would reduce the trie size to about 50kB for case-sensitive filesystems, and
> about 55kB on case-folding filesystems.

Honestly I wouldn't worry about demand loading it too much.  This is a
fairly special case code for NAS servers, and should not affect normal
uses now that we use symbol_get.  Let's get back to the fundamentals.

> >It's a chicken and egg situation. I'd much prefer we enforce clean
> >utf8 from the start, because if we don't we'll never be able to do
> >that. And other filesystems (e.g. ZFS) allow you to do reject
> >anything that is not clean utf8....
> 
> As I understand it, this is optional in ZFS. I wonder what people's
> experiences are with this.

It is as optional as your utf8 support for XFS is.  But they do
enforce valid utf8 if they use utf8 normalization for file name
comparisms, be that case sensitive or insensitive.  Take a look at the
zfs(8) man page.

> - Forbid non-UTF-8 filenames
> - Allow non-UTF-8 filenames
> - Make it a mount option
> - Make it a mkfs option

My take on this is:

 - I think we'll have to prevent non-utf8 file names for any cases where
   we use utf8 normalization.  If you do not use utf8 normalization
   it's plain old Unix everything is allowed.
 
 - I think utf8 normalization vs not should be mkfs option, to make sure
   everyone including kernel and repair knows what sort of filesystem
   deal with.

 - case insensitive matching for utf8 normalized filesystems should be
   a runtime decision.  mount time for now, but Samba people would be
   extremly happy to allow per-operation or per-process CI matching.
   But that is another totally different discusion I'd like to keep
   separate, I just want to make sure the disk format allows for it for
   now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
