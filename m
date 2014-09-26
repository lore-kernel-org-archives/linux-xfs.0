Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 011B87F56
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 12:04:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E447E8F8040
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 10:04:11 -0700 (PDT)
Received: from mail.samba.org (fn.samba.org [216.83.154.106]) by cuda.sgi.com
	with ESMTP id GG9OBJeEH9eoH7l8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 10:04:10 -0700 (PDT)
Date: Fri, 26 Sep 2014 10:04:07 -0700
From: Jeremy Allison <jra@samba.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140926170407.GB6012@samba2>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926165605.GA25274@infradead.org>
Reply-To: Jeremy Allison <jra@samba.org>
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
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Olaf Weber <olaf@sgi.com>, linux-fsdevel@vger.kernel.org

On Fri, Sep 26, 2014 at 09:56:05AM -0700, Christoph Hellwig wrote:
> 
> My take on this is:
> 
>  - I think we'll have to prevent non-utf8 file names for any cases where
>    we use utf8 normalization.  If you do not use utf8 normalization
>    it's plain old Unix everything is allowed.
>  
>  - I think utf8 normalization vs not should be mkfs option, to make sure
>    everyone including kernel and repair knows what sort of filesystem
>    deal with.
> 
>  - case insensitive matching for utf8 normalized filesystems should be
>    a runtime decision.  mount time for now, but Samba people would be
>    extremly happy to allow per-operation or per-process CI matching.
>    But that is another totally different discusion I'd like to keep
>    separate, I just want to make sure the disk format allows for it for
>    now.

Actually, I'm so eager for case-insensitive matching I'd
take "at format time", as with ZFS :-) :-).

Having CI matching can speed up Samba operations by a
factor of 10 on large directories (warning, number made
up, depending on the number of entries per dir :-).

Jeremy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
