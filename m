Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C5167F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 15:12:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7690AC001
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 13:11:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9vn22mskb0OzEM1z for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 13:11:55 -0800 (PST)
Date: Sat, 7 Mar 2015 08:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
Message-ID: <20150306211136.GB13958@dastard>
References: <54EF1A8F.7030505@pythonanywhere.com>
	<54F856E7.10006@pythonanywhere.com> <54F87BF3.3000405@sandeen.net>
	<54F88CEC.4030009@pythonanywhere.com> <54F89201.60805@sandeen.net>
	<54F893AF.2070406@pythonanywhere.com>
	<54F895FA.4050205@sandeen.net>
	<54F89B47.4010702@pythonanywhere.com>
	<54F8B7D6.2000501@sandeen.net>
	<54F98F20.9000208@pythonanywhere.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F98F20.9000208@pythonanywhere.com>
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
To: Harry Percival <harry@pythonanywhere.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 06, 2015 at 11:27:28AM +0000, Harry Percival wrote:
> Glad we managed to nail down a probable culprit!   Here's hoping
> Debian and Ubuntu pull in a new kernel :)
> 
> In other news, any advice on running this
> 
>     xfstests:src/bstat
> 
> command as a way of estimating how long a quotacheck will take?

It will give you an idea - quotacheck uses bulkstat, too.

> Would it still be a useful estimator?  Do you think it would
> significantly affect the performance of a disk that's under fairly
> heavy use?

Of course. Bulkstat drives the disks as hard as they will go.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
