Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B1AC7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 08:56:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15A318F8039
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 06:56:46 -0700 (PDT)
Received: from mail-ee0-f47.google.com (mail-ee0-f47.google.com
	[74.125.83.47]) by cuda.sgi.com with ESMTP id lk4M4SSxXVnJVydz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 06:56:44 -0700 (PDT)
Received: by mail-ee0-f47.google.com with SMTP id t10so5441476eei.20
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 06:56:43 -0700 (PDT)
Date: Wed, 29 May 2013 15:56:41 +0200
From: Paolo Pisati <p.pisati@gmail.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130529135641.GB4889@luxor.wired.org>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
	<20130520170710.GA2591@luxor.wired.org>
	<20130521000208.GF24543@dastard>
	<20130523143456.GB19815@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130523143456.GB19815@luxor.wired.org>
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
Cc: xfs@oss.sgi.com, Paolo Pisati <p.pisati@gmail.com>

On Thu, May 23, 2013 at 04:34:56PM +0200, Paolo Pisati wrote:
> On Tue, May 21, 2013 at 10:02:09AM +1000, Dave Chinner wrote:
> > 
> > And that fix I mentioned will be useless if you don't apply the
> > patch that avoids the vmap allocation problem....
> 
> 
> ok, so i recompiled a kernel+aforementioend fix, i repartitioned my disk and i
> ran the swift-bench for 2 days in a row until i got this:

i'm testing a 3.5.y kernel plus those 3 patches:

549142a xfs: don't use speculative prealloc for small files
f0843f4 xfs: limit speculative prealloc size on sparse files
454da09 xfs: inode allocation should use unmapped buffers.

and i can confirm that:

-using a small fs (2G) i cannot reproduce any -ENOSPC or vmalloc() problem
anymore, the benchmark runs until running out of inodes 

-using a bigger fs (~250G), two days and my tests are still running good

-- 
bye,
p.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
