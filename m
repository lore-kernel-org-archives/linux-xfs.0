Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPFln1W246645 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 09:47:49 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 780A8AC010
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 07:48:13 -0800 (PST)
Message-ID: <4B0D51BC.5020806@sgi.com>
Date: Wed, 25 Nov 2009 09:48:12 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: consistency checks
References: <vmime.4b0c0e17.1df4.5b5ba8b45ea0c16c@mail.datux.nl>
In-Reply-To: <vmime.4b0c0e17.1df4.5b5ba8b45ea0c16c@mail.datux.nl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rick Meertens <rick@datux.nl>
Cc: xfs@oss.sgi.com

Rick Meertens wrote:
> Does the xfs backup tools contain any backup media consistency checks? I 
> want to verify if the old backup on a tape is corrupt, with a checksum orso.
> 
>  
> 
> I have seen that the xfsdump inventory can be checked on consistency, 
> but nothing found for the tapes

Not really -- unfortunately most of the structures and data written
by xfsdump are not checksummed.

The closest thing is to use xfrestore -t. This will read the entire
dump, listing all of the files it contains. So you'll at least know
whether or not there are unreadable blocks on the media, and whether
the structure of the dump is okay, but not whether your file data is
consistent.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
