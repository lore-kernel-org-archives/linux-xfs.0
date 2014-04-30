Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8288329DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:50:17 -0500 (CDT)
Message-ID: <53610DA7.8070806@sgi.com>
Date: Wed, 30 Apr 2014 09:50:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: remove unused argument in trans_iput
References: <20140430134844.924376330@sgi.com>
	<20140430135319.660238697@sgi.com> <53610D16.9040609@sandeen.net>
In-Reply-To: <53610D16.9040609@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 04/30/14 09:47, Eric Sandeen wrote:
> On 4/30/14, 8:48 AM, Mark Tinguely wrote:
>> >  Remove the unused second argument to xfs_iput() and
>> >  xfs_trans_iput().
>> >
>> >  Introduce the define "IRELE()" and use in place of xfs_iput().
> Why do this?  We had been moving away from the upper-case-macro-
> redefined-to-a-function meme... what does this #define gain?
>
> libxfs_iget/libxfs_iput pairs seem more obvious than
> libxfs_iget/IRELE()...
>
> Thanks,
> -Eric
>

To be consistent with the kernel code.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
