Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F6B629DFA
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 14:14:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C77E304051
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 12:14:45 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	yyEZXVyDpQCOXpiC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 12:14:40 -0700 (PDT)
Received: by mail-ie0-f170.google.com with SMTP id at1so2215944iec.1
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 12:14:40 -0700 (PDT)
Message-ID: <5172E91F.7040107@inktank.com>
Date: Sat, 20 Apr 2013 14:14:39 -0500
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: Re: Deprecating xfs_check
References: <1365716708.3762.32154.camel@chandra-dt.ibm.com>
	<20130411221754.GI22182@sgi.com> <516740B8.4030704@sgi.com>
	<20130412010407.GE31207@dastard>
	<1366133266.3762.32211.camel@chandra-dt.ibm.com>
In-Reply-To: <1366133266.3762.32211.camel@chandra-dt.ibm.com>
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

On 04/16/2013 12:27 PM, Chandra Seetharaman wrote:
> Hello All,
> 
> While trying to replace xfs_check with xfs_repair -n in xfstests, I
> found that xfs_check is quiet if all is well, and prints information
> only if something is wrong. But, xfs_repair -n always prints information
> on different phases etc.,
> 
> What should be our approach ?
>  1. add a -q option to xfs_repair, which prints no message at all
>  2. add a -q option, and it will be quiet, but is valid only if -n 
>     is specified.
>  3. Leave it as is. Since users have to change their scripts anyways to 
>     replace xfs_check, they can as well change the logic around the 
>     output.

I like option 1 the best.  But any of them is reasonable.	-Alex

> Please suggest.
> 
> Regards,
> 
> Chandra 

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
