Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10E447CB9
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7944EAC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:56:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id P7iJIggY2zDNzBJz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:56:08 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:56:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: remove put_value from attr ->put_listent context
Message-ID: <20160315075607.GC25971@infradead.org>
References: <56E3425E.40509@redhat.com>
 <56E342BD.2030103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56E342BD.2030103@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Mar 11, 2016 at 04:12:13PM -0600, Eric Sandeen wrote:
> The put_value context member is never set; remove it
> and the conditional test in xfs_attr3_leaf_list_int().

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although this should probably go along with the previous patch)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
