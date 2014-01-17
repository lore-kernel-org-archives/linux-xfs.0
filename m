Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A8A5F7F76
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:12:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8482430406A
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 13:12:20 -0800 (PST)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id HTe8CbmA4HmBWPVF for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 13:12:18 -0800 (PST)
Subject: Re: [PATCH 2/3] xfs: rename xfs_buftarg structure members
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <52D991E5.1010300@sandeen.net>
References: <52D6CC91.6000408@redhat.com> <52D9910C.9000205@sandeen.net>
	<52D991E5.1010300@sandeen.net>
Date: Fri, 17 Jan 2014 21:12:17 +0000
Message-Id: <1389993137.4298.938.camel@localhost.localdomain>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

- if ((pos & target->bt_smask) || (size & target->bt_smask)) {
+ if ((pos || size) & target->bt_meta_sectormask) {

nope...

|| needs to be |

(pos || size) yields a boolean



 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
