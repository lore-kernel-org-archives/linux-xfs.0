Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8F527F3F
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 15:25:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBCF78F8035
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 13:25:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9b7cI5x2mhlwiHBF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 13:25:34 -0700 (PDT)
Date: Sun, 21 Jun 2015 16:25:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: validate transaction header length on log
	recovery
Message-ID: <20150621202526.GA3955@bfoster.bfoster>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
	<1434631741-50856-3-git-send-email-bfoster@redhat.com>
	<20150621092722.GA7914@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150621092722.GA7914@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sun, Jun 21, 2015 at 02:27:22AM -0700, Christoph Hellwig wrote:
> This looks sensible to me, but I still can't make sense of the old
> code which just conditionally copied it even after taking a brief
> look at the pre-git history of this code.  Does anyone understand why
> the code was like this?   Fixing code that seems to have had an
> intention I can't make sense of always feel dangerous.
> 

Yeah, I couldn't really make much sense of the original code either. My
reasoning at the time was that the memcpy() seemed superfluous in this
case, as we wouldn't add anything to trans->r_itemq and end up doing the
memcpy() again the next time around.

Taking another look at other xlog_recover_add_item() callsites, there is
this in the xlog_recover_add_to_cont_trans() case:

        if (list_empty(&trans->r_itemq)) {
                /* finish copying rest of trans header */
                xlog_recover_add_item(&trans->r_itemq);
                ptr = (xfs_caddr_t) &trans->r_theader +
                                sizeof(xfs_trans_header_t) - len;
                memcpy(ptr, dp, len);
                return 0;
        }

... which according to the code/comment, seems to imply that the
transaction header could be split across op records..? I'm not terribly
familiar with the log on-disk format. Does this sound sane?

If so, perhaps the patch is wrong and we should only bail if the length
in either of these two cases is obviously invalid (e.g., it exceeds the
size of the full in-core structure). Perhaps there's also more
validation that can occur here: can we assert that this should mean
we're at the end of the operation record in the first short copy
instance? I'll probably have to stare at this some more with regard to
that.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
