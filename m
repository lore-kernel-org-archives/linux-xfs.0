Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 818717F51
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 10:46:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64F6A8F8037
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 08:46:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tGbhA1qsV07Pknik for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 08:46:25 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A5ED165D6BBC
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 10:46:24 -0600 (CST)
Subject: Re: XFS corruptions
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5669AC60.1070709@sandeen.net>
Date: Thu, 10 Dec 2015 10:46:24 -0600
MIME-Version: 1.0
In-Reply-To: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
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
To: xfs@oss.sgi.com

On 11/30/15 10:51 AM, Sandeep Patel wrote:
> Hi,

> We have multiple 22 disk raid 6 arrays using LSI 9280-24i4e raid
> cards, all using enterprise grade drives. The array is setup with
> physical drive cache disabled and mounted using inode64 with
> nobarriers option in Oracle Linux Server release 6.6, kernel version
> 3.8.13-55.1.5.el6uek.x86_64. We are suffering from corruptions with
> xfs_repair unable to permanently fix the the issues.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Does that mean it finds and fixes something "temporarily?"  If so, what?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
