Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A99E47FE2
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 12:06:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47D10AC001
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 10:06:06 -0700 (PDT)
Date: Fri, 26 Sep 2014 10:06:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140926170604.GA21287@infradead.org>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926170407.GB6012@samba2>
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
To: Jeremy Allison <jra@samba.org>
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Olaf Weber <olaf@sgi.com>, linux-fsdevel@vger.kernel.org

On Fri, Sep 26, 2014 at 10:04:07AM -0700, Jeremy Allison wrote:
> Actually, I'm so eager for case-insensitive matching I'd
> take "at format time", as with ZFS :-) :-).

You already get this with XFS as long as you limit yourself to
7-bit ASCII :)  And utf-8 with Olaf's patches as-is.

Maybe time to give them some testing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
