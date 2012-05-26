Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4QG0Iqw170620 for <xfs@oss.sgi.com>; Sat, 26 May 2012 11:00:18 -0500
Received: from asav4.lyse.net (asav4.lyse.net [81.167.36.150]) by cuda.sgi.com
	with ESMTP id Ng6zfYwucGpzbg4p for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 09:00:16 -0700 (PDT)
Message-ID: <4FC0FE0C.8080800@hesbynett.no>
Date: Sat, 26 May 2012 18:00:12 +0200
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120525165719.GV16099@sgi.com>
	<20120525165938.GA13555@infradead.org>
In-Reply-To: <20120525165938.GA13555@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Joe Landman <joe.landman@gmail.com>

On 25/05/12 18:59, Christoph Hellwig wrote:
> On Fri, May 25, 2012 at 11:57:19AM -0500, Ben Myers wrote:
>> There are a couple recent fixes related to discard that are probably
>> appropriate for 3.2-stable.
>
> Discard is not enabled by default.
>

You would not want to enable discard if slow deletes are an issue - 
benchmarks (on ext4) show that enabling trim makes metadata operations, 
and delete in particular, much slower.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
