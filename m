Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93AFD7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:46:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B3E5304048
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 13:46:03 -0700 (PDT)
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id 7sdh3ZWSt5mQ88iW
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 13:45:59 -0700 (PDT)
References: <578E78B0.2010602@ashurst.eu.org> <578E7988.6020102@ashurst.eu.org>
	<6eb6490f-0eb8-e488-8d71-ce86e5113f73@sandeen.net>
From: Andy Bennett <andyjpb@ashurst.eu.org>
Message-ID: <578E9185.9080901@ashurst.eu.org>
Date: Tue, 19 Jul 2016 21:45:57 +0100
MIME-Version: 1.0
In-Reply-To: <6eb6490f-0eb8-e488-8d71-ce86e5113f73@sandeen.net>
Subject: Re: xfsdump quota failures
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi,

>> My Google-fu failed me before I posted but, of course, succeeded
>> immediately after I hit send:
>>
>> http://xfs.9218.n7.nabble.com/xfsdump-3-0-6-ERROR-xfs-quota-failed-with-exit-status-1-td30691.html
>>
>> Does that mean that this error can be safely ignored in xfs_dump 3.0.6?
> 
> I believe so.  Can you confirm that quotas were correctly
> restored?

Thanks!

How would I confirm that? I'm only taking a dump at this time and if I
pipe the dump file into `xfsrestore -i` it doesn't say anything about
quota or seem to have any commands to inspect them.





Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0290 DA75 E982 7D99 A51F  E46A 387A 7695 7EBA 75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
