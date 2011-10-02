Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92G6uNb136376 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 11:06:57 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D71FD143A9A1
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 09:13:21 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id RJapGSQyymEeONfq for
	<xfs@oss.sgi.com>; Sun, 02 Oct 2011 09:13:21 -0700 (PDT)
Message-ID: <4E888C0D.9060701@oracle.com>
Date: Mon, 03 Oct 2011 00:06:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: SEEK_DATA/SEEK_HOLE support
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
In-Reply-To: <20111002154259.GA14543@infradead.org>
Reply-To: jeff.liu@oracle.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

Thanks for your prompt response!
On 10/02/2011 11:42 PM, Christoph Hellwig wrote:

> On Sun, Oct 02, 2011 at 11:04:31PM +0800, Jeff Liu wrote:
>> Dear developer,
>>
>> Does anyone already worked on SEEK_DATA/SEEK_HOLE for XFS? I'd like to
>> implement it if not. :)
> 
> Dave mentioned he had a basic implementation, he might have some code
> that you can improve on.
> 
> Did we get consensus about the the semantics of them for unwritten
> extents?  If we want them to be exact in the fact of unwritten extents
> that is going to be the most work, e.g. if we find an unwritten extent
> we'll then have to do a pagecache lookup and check if pages are dirty
> and in that case not treat them as a hole.

IMHO, to avoid data loss in some user application like cp(1), for
unwritten extents, we always need to check the pages status.  Just as
you mentioned above, return the map offset if pages are dirty for
SEEK_DATA, or a hole found.


-Jeff

> 
> The rest of the implementation should be easy, e.g. doing something like
> the following pseudo-code which missed all the proper error codes and
> conversions from the lseek arguments to filesystem blocks and the
> required locking around it:
> 
> 
> seek_hole()
> {
> 	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got,
> 			&prev);
> 
> 	for (;;) {
> 		if (eof) {
> 			/* past the file, nothing do here */
> 			return;
> 		}
> 
> 		if (got.br_startoff > bno)
> 			/* found hole, return it */
> 			return;
> 		}
> 
> 		if (++lastx == ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
> 			/* reached EOF */
> 			return;
> 		}
> 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
> 	}
> }
> 
> seek_data()
> {
> 	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got,
> 			&prev);
> 
> 	for (;;) {
> 		if (eof) {
> 			/* past the file, nothing do here */
> 			return;
> 		}
> 
> 		/* next data extent */
> 		return got.br_startoff < bno ? bno : got.br_startof;
> 	}
> }
> 
> 	


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
