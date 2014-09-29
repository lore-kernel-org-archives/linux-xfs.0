Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAB3A7FD7
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 06:06:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65FC9AC005
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 04:06:10 -0700 (PDT)
Date: Mon, 29 Sep 2014 04:06:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140929110608.GB17258@infradead.org>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2> <5425C067.7080904@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5425C067.7080904@sgi.com>
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
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, Jeremy Allison <jra@samba.org>

On Fri, Sep 26, 2014 at 09:37:11PM +0200, Olaf Weber wrote:
> My argument against "mount time case-insensitivity" and for "mkfs time
> case-insensitivity" is related to switching from the case-sensitive domain
> to the case-insensitive one.
> 
> For case-sensitive, from "README" to "readme" there are 64 different
> possible filenames.  Let's say you create 63 out of these 64. Now remount
> the filesystem case-insensitive, and try to open by the 64th version of
> "readme". It is not an exact match for any of the 63 candidate files, and a
> case-insensitive match to all 63 candidate files. Which of these 63 files
> should be opened, and why that one in particular?

Well, the point is not that we use the CI-capable hash all the time.  I
fully expect the current XFS behavior to remain the default for normal
systems forever.  I just want to make sure that the CI implementation
you chose can also allow mixed lookups if we desire.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
