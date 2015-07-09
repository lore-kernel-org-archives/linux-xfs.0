Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C98267F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 03:46:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2DAA8F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 01:46:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id C4YInVbBGK1e8YD9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 01:46:08 -0700 (PDT)
Date: Thu, 9 Jul 2015 10:46:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: regarding journaling mode
Message-ID: <20150709084602.GA2900@quack.suse.cz>
References: <CAMcfJ7sZaLwO7Gz8f7E9GBrX75Ddc8JvLntPRpjw=KPNOV7TLg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMcfJ7sZaLwO7Gz8f7E9GBrX75Ddc8JvLntPRpjw=KPNOV7TLg@mail.gmail.com>
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
To: Rakesh Patel <patelrakeshcomp@gmail.com>
Cc: xfs@oss.sgi.com

On Thu 09-07-15 10:18:55, Rakesh Patel wrote:
> https://www.kernel.org/doc/Documentation/filesystems/ext4.txt
> 
> data=writeback		Data ordering is not preserved, data may be written
> 			into the main file system after its metadata has been
> 			committed to the journal.

But this is about ext4, not xfs. XFS works differently and provides
necessary data safety guarantees.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
