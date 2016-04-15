Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13A167CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:09:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAD178F8033
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:09:13 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0082.hostedemail.com
	[216.40.44.82]) by cuda.sgi.com with ESMTP id UzDAa21CGQvL4Epl
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2016 12:09:11 -0700 (PDT)
Message-ID: <1460747340.19090.42.camel@perches.com>
Subject: xfs: compiler implementation dependent behavior?
From: Joe Perches <joe@perches.com>
Date: Fri, 15 Apr 2016 12:09:00 -0700
Mime-Version: 1.0
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

The value stored in *cycle in xlog_crack_grant_head_val
in xfs_log_priv.h is compiler implementation dependent.

Does it matter?

static inline void
xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
{
	*cycle = val >> 32;
	*space = val & 0xffffffff;
}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
