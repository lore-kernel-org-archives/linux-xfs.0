Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UH2JY9205363 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 12:02:30 -0500
Received: from sensor2.syn-recon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E6FC13DC808
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 10:02:18 -0700 (PDT)
Received: from sensor2.syn-recon.net (sensor2.syn-recon.net [209.61.158.40])
	by cuda.sgi.com with ESMTP id o4qnLHoKkl8bEBao for
	<xfs@oss.sgi.com>; Mon, 30 Mar 2009 10:02:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [64.39.1.185])
	by sensor2.syn-recon.net (Postfix) with ESMTP id 5B6D23F269C
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 12:01:24 -0500 (CDT)
Message-ID: <49D0FAE3.1090001@blackopscode.com>
Date: Mon, 30 Mar 2009 12:01:23 -0500
From: Florian Hines <fhines@blackopscode.com>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data
References: <49CD2EF0.9060009@blackopscode.com> <49CD359E.905@sandeen.net>
In-Reply-To: <49CD359E.905@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Eric Sandeen wrote:
> Florian Hines wrote:
>> Hey everybody,
>>
>> Over the last few day's I've been getting a rash (8 so far) of disk's
>> throwing the error "Filesystem "sdxX": Corruption of in-memory data
>> detected.  Shutting down filesystem: sdxX".  xfs_check never seem's to
>> find anything and just unmounting and remounting solves the issue at
>> least for awhile.   
> 
> try xfs_repair, with -n if you want a dry run.
> 
> It's canceling a dirty transaction, I'm not sure why.  The message is a
> little misleading.  Want to try 2.6.29? :)

I'll give xfs_repair a run next time I get one.  Thanks!

Florian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
