Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA2FF7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C11BAC002
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:51:42 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 721CiXpWEtmdt2Es (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 19:51:37 -0700 (PDT)
Date: Tue, 15 Apr 2014 22:51:34 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
Message-ID: <20140416025134.GB21807@thunk.org>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
	<1397580076-19826-2-git-send-email-lczerner@redhat.com>
	<20140415220220.GR15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415220220.GR15995@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 08:02:20AM +1000, Dave Chinner wrote:
> On Tue, Apr 15, 2014 at 06:41:15PM +0200, Lukas Czerner wrote:
> > Currently punch hole and collapse range fallocate operation are not
> > allowed on append only file. This should be case for zero range as well.
> > Fix it by allowing only pure fallocate (possibly with keep size set).
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, updated with Dave's suggested added parenthesis.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
