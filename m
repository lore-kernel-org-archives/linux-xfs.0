Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 369957F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:18:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AC85304043
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 12:18:50 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id ogncnszNAxv1Ga8I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 12:18:48 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <cody@linux.vnet.ibm.com>;
	Tue, 11 Feb 2014 15:18:48 -0500
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com
	[9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 69A1638C804F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 15:18:46 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22036.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	s1BKIkrM7274952 for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:18:46 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	s1BKIj9D025117 for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 15:18:45 -0500
Message-ID: <52FA8598.1060805@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 12:18:32 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: xfs_repair fails to repair, run under valgrind shows "Invalid
	read..." and XFS_CORRUPTION_ERROR
References: <52FA8021.9050604@linux.vnet.ibm.com>
	<52FA840A.7090309@sandeen.net>
In-Reply-To: <52FA840A.7090309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 02/11/2014 12:11 PM, Eric Sandeen wrote:
> On 2/11/14, 1:55 PM, Cody P Schafer wrote:
>> xfsprogs version: v3.2.0-alpha2-14-g6e79202
>>
>> uname: Linux hostname 3.11.10-301.fc20.ppc64 #1 SMP Tue Dec 10 00:35:15 MST 2013 ppc64 POWER8 (architected), altivec supported CHRP IBM,8286-42A GNU/Linux
>>
>> full log attached.
>
> Yikes, that's one destroyed filesystem.  What happened?
>

Well, initially? no idea. This is the second time that the repair 
failed, so the first one may not have been too kind to the system. The 
fs still mounts fine (or did before this particular failed repair), but 
has random file corruption (pieces of files get replaced with other 
junk). Most of the time without any XFS_CORRUPTION errors showing up in 
dmesg (though they did appear a few times in the past).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
