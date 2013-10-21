Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7571B7F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:06:58 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 039DCAC005
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:06:54 -0700 (PDT)
Message-ID: <52658986.2030705@sgi.com>
Date: Mon, 21 Oct 2013 15:07:34 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V4 0/2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore are not lost
References: <20131011041911.238407600@sgi.com>
	<20131021193830.885912820@sgi.com>
In-Reply-To: <20131021193830.885912820@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 10/21/2013 03:02 PM, rjohnston@sgi.com wrote:
> Extended attributes are lost after multi-stream xfsdump/xfsrestore
> of wholly-sparse files.  This can happen in two ways:
>
>    1 - The restore succeeds, however the extended attributes are lost
>    2 - The restore in not successful because xfsrestore segfaults
>        with the following warning:
>
>           "partial_reg: Out of records. Extend attrs applied
>            early."
>
> ---
> Changelog
> V2:
>    Updated test description and comments
>    Changed test status to default to failure
>    Added missing _requires_XXXX statements
>    Removed the attr root (-R) namespace argument
> V3:
>    Split into 2 tests and used functions from the common
>    directory where appropriate.
>
V4:
     Addressed Eric's comments
> --Rich
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
