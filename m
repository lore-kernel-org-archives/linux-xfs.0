Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D10237CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 12:42:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A19098F8049
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 10:41:58 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id vHuc0doi0fMz8QdR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 10:41:55 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id C922B20B69
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 19:41:53 +0200 (CEST)
Date: Tue, 9 Aug 2016 19:41:05 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
Message-ID: <20160809174105.GA5907@nyan>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<ea8cca9bf1dbeb13a788f85f73d6bafbcc374a89.1470555003.git.felix.janda@posteo.de>
	<20160809073611.GC25647@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809073611.GC25647@infradead.org>
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

Thanks for reviewing the patch series!

> Does this also error out for libraries that don't support large
> off_t at all?  I think that would be helpful to add if not there yet.

I do not quite understand. Do you refer to libraries using libxfs or
the external libraries used by xfsprogs?

For the latter, none of them exports interfaces using off_t. libblkid
has its own blkid_loff_t, which is defined as int64_t.

For the former, patch 13 forces any user of libxfs to enable
transparent LFS, by for example adding AC_SYS_LARGEFILE.

The approach of libblkid is the same as what I was suggesting in a
previous patch, but maybe it is good to break applications using
libxfs and not transparent LFS. For example this seems to be the case
for ceph. It has not enabled transparent LFS but mixes off_t and
off64_t. So it is likely that it has some LFS related runtime bugs on
32bit systems. If the xfs header included the off_t size check,
building ceph on 32bit systems would lead to a less subtle compile
failure.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
