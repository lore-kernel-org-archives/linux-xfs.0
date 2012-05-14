Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4E1jBuB050550 for <xfs@oss.sgi.com>; Sun, 13 May 2012 20:45:11 -0500
Received: from boosthardware.localdomain (boosthardware.com [88.198.122.139])
	by cuda.sgi.com with ESMTP id XufMzX7L0eVne9Wy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 May 2012 18:45:10 -0700 (PDT)
Message-ID: <59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
In-Reply-To: <20120511165012.GC16099@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
	<20120511165012.GC16099@sgi.com>
Date: Mon, 14 May 2012 03:45:06 +0200 (CEST)
Subject: Re: file corruption issue
From: "Patrick Shirkey" <pshirkey@boosthardware.com>
MIME-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com


On Fri, May 11, 2012 6:50 pm, Ben Myers wrote:
> On Fri, May 11, 2012 at 03:27:02AM +0200, Patrick Shirkey wrote:
>> I have some HP machines running centos:
>>
>> kernel 2.6.32-042stab049.6
>> AMD Opteron(tm) Processor 6180 SE
>> RAM:   528 GB
>> RAID bus controller: Hewlett-Packard Company Smart Array G6 controllers
>>
>> We have experienced some kernel crashes due to a kernel bug with
>> interleaving ram on this hardware which require hard reset of the
>> machines.
>>
>> After reboot we are finding that there is severe file corruption on the
>> xfs file system where TBs of readonly databases are getting partially or
>> fully truncated.
>>
>> Has anyone come across this or similar?
>
> This rings a bell for me but I can't be certain.  Could you provide a
> metadump?
>

The machines are live so we have already restored the data several times.
Will a metadump from the existing file system be useful or do you need it
post crash?




--
Patrick Shirkey
Boost Hardware Ltd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
