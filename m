Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 01:36:29 -0700 (PDT)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6H8aJDW008544
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 01:36:19 -0700
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1G2NeD-0005Eb-9j
	for linux-xfs@oss.sgi.com; Mon, 17 Jul 2006 00:36:09 -0700
Message-ID: <5356806.post@talk.nabble.com>
Date: Mon, 17 Jul 2006 00:36:09 -0700 (PDT)
From: Cosmo Nova <cs_mcc98@hotmail.com>
Subject: Re: file system defragmentation
In-Reply-To: <43311567.3060208@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi, you mentioned delayed allocation. What is the size of the buffer holding
the data, before they're actually written to disk? How can it tackle growing
files?

If I have a DVR system of 16 channels. They keep writing data to the disk in
pieces of video files. I read some spec of xfs. Apart from extend-based
allocation, there're allocaiton groups in xfs. I would like to ask, does
XFS's allocation groups work similar as JFS's, which would lock an
allocation group for individual file write? How does the allocation group in
XFS work? And how would it help the fragmentation problem?

Thankyou!
-- 
View this message in context: http://www.nabble.com/file-system-defragmentation-tf255485.html#a5356806
Sent from the Xfs - General forum at Nabble.com.
