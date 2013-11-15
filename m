Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1310E7F5F
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:30:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5D5F8F8035
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:30:35 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QiCBA0psdTL2ZrWX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:30:34 -0800 (PST)
Message-ID: <5285A33C.4040808@oracle.com>
Date: Fri, 15 Nov 2013 12:29:48 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 0/6] list: introduce list_last_entry_or_null()
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
To: linux-kernel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

Hi Folks,

This patch is trying to introduce a new list helper to retrieve the
last entry or return NULL if the list is empty corresponding to it,
which is inspired by Jiri Pirko's list_first_entry_or_null().

With this trivial helper, we could get a little benefit to simplify
the code logic of xfs_ail_max() and make the code looks a bit more
consistent with xfs_ail_min() which has already been simplified
via list_first_entry_or_null().

Moreover, as a per simple grep against fs as well as driver's tree,
I think there are some other places could make use of it for similar
purpose, here I spread this helper over some file systems as well.

Any comments are welcome!

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
