Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33E0B29DF8
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 07:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 223948F8033
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 05:47:52 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id j6vzHhObFzGeD9JE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Mon, 06 May 2013 05:47:33 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r46ClVlp026414
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Mon, 6 May 2013 14:47:31 +0200
Message-ID: <5187A663.707@itwm.fraunhofer.de>
Date: Mon, 06 May 2013 14:47:31 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard>
In-Reply-To: <20130506122844.GL19978@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

On 05/06/2013 02:28 PM, Dave Chinner wrote:
> On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
>> And anpther protection fault, this time with 3.9.0. Always happens
>> on one of the servers. Its ECC memory, so I don't suspect a faulty
>> memory bank. Going to fsck now-
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Isn't that a bit overhead? And I can't provide /proc/meminfo and others, 
as this issue causes a kernel panic a few traces later.

>
>>
>>> [303340.514052] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>>> [303340.517913] Modules linked in: fhgfs(O) fhgfs_client_opentk(O)
>
> Kernel tainted with out of tree modules. Can you reproduce the
> problem with them?

The modules are unused, as this is the server side. I disabled client 
packages now and will re-run. But I really think that we should look for 
memory/list corruption outside of fhgfs. Also very unlikely that always 
only xfs would suffer, as there is also running ext4 for fhgfs meta data.
Also, it took from Friday evening till this morning to run into the 
crash, so the next occurance might take some time. And I think tracing 
xfs is out of question, as I need the disk space to store data (the 
client side is running our stress test suite).


Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
