Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8350C7F51
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 20:45:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CC72AC006
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 18:45:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id c4dFCP7mzZVRShF0 for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 18:45:10 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: why crc req on free-inobt & file-type-indir options?
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <55C55265.4080309@tlinx.org>
Date: Fri, 7 Aug 2015 18:45:07 -0700
Message-Id: <620A4212-818A-4375-90FC-DBB0B91A84DB@sandeen.net>
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org> <20150807225531.GG3902@dastard>
	<55C55265.4080309@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>



> On Aug 7, 2015, at 5:50 PM, L.A. Walsh <xfs@tlinx.org> wrote:
> 
> 
> 
> Dave Chinner wrote:
> 
>> xfsprogs 3.1.11 doesn't support CRCs. 3.2.0 was the first version of
>> xfsprogs to support CRCs, and 3.2.1 (IIRC) was the first to support
>> finobt, so the make binary came from a different build to the xfs_db
>> binary that xfs_admin executes.
> ----
> I'll have to do some research on this.
> 
> Q: should the versions of xfsdump&restore be the same as the rest of the xfsprogs?
Nope, they are separate packages with separate versioning.

-Eric

> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
