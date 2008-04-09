Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 18:50:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m391mpwJ019980
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 18:48:55 -0700
Date: Wed, 09 Apr 2008 11:53:20 +1000
Subject: Re: [PATCH 0/7] XFS: case-insensitive lookup and Unicode support
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080408114513.GA31734@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t9bl66sx3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080408114513.GA31734@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, 08 Apr 2008 21:45:13 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> btw, a little comment on how to proceed.  After your xfs_name patch it
> would be good to get the nameops and leafn cleanup in as almost
> independent cleanups and then the ascii only CI but already using the
> complex and correct lookup method.  I think unicocde will take a bit
> longer to sort out and getting the simpler bit in first would be
> helpful.

Yep, that is how I was proceeding when working on the return name patch
with the xfs_vn_ci_lookup code.

So, it will be:
1 xfs_name
2 leafn refactor
3 nameops
4 ascii ci
5 unicode ci
6 nls

With NLS, it would be very nice if the Linux VFS or some layer above
always pushed UTF-8 strings down rather than handling it in the
filesystems that require it (there are about half a dozen at least
that I'm aware of).

Barry.
