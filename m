Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 03:33:57 -0700 (PDT)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JAXfDW010519
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 03:33:41 -0700
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1G39Mg-000399-3V
	for linux-xfs@oss.sgi.com; Wed, 19 Jul 2006 03:33:14 -0700
Message-ID: <5393901.post@talk.nabble.com>
Date: Wed, 19 Jul 2006 03:33:13 -0700 (PDT)
From: Cosmo Nova <cs_mcc98@hotmail.com>
Subject: Re: file system defragmentation
In-Reply-To: <20060718213304.GA27287@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com> <20060717141917.GY2114946@melbourne.sgi.com> <5374022.post@talk.nabble.com> <20060718213304.GA27287@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


If there are AG locks, but multiple files can write in the same AG, how "AG
lock" is interpreted by XFS then? What does it really do?

For pre-allocation and delayed allocation, do they belong to the feature set
of XFS? Or are they application dependant?

I am trying to compare filesystems, especially xfs vs jfs. I found that
jfs's per AG locking would only allow one file to be written per AG, which
helps a lot to prevent fragmentation (according to experiment results).
There're no pre-allocation and delayed allocation in JFS though. Comparing
the experiment results, XFS is doing a good job, giving 6-10 fragments
(compare to majority of single fragment in JFS...). So answers of the above
questions with numbers would help a lot. Thanks!
-- 
View this message in context: http://www.nabble.com/file-system-defragmentation-tf255485.html#a5393901
Sent from the Xfs - General forum at Nabble.com.
