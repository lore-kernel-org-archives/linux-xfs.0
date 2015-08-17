Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AE377F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 10:04:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E9188F804B
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 08:04:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id j6kiau1s9JO8yAze (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 08:04:02 -0700 (PDT)
Date: Mon, 17 Aug 2015 08:04:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 09/11] xfsprogs: Add mntent.h check into autoconf
Message-ID: <20150817150401.GA29056@infradead.org>
References: <20150804112153.GG18906@infradead.org>
	<1439823687-7279-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439823687-7279-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

This looks mostly fine.  I think you could just add the
AC_CHECK_HEADERS directly to configure.ac, but otherwise it's exactly
what I though.

Can you please resend all your pending patches in a single series,
and move the UPDATES: lines and other internal changelogs to the
cover letter instead of the patch descriptions?

Thanks for doing this work!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
