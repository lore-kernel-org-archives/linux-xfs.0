Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD98A8064
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:20:00 -0600 (CST)
Message-ID: <51352C1C.40409@sgi.com>
Date: Mon, 4 Mar 2013 17:19:56 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
	<51310046.5090306@sgi.com> <878v66h9ks.fsf@openvz.org>
In-Reply-To: <878v66h9ks.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 03/01/2013 07:30 PM, Dmitry Monakhov wrote:
> On Fri, 1 Mar 2013 13:23:50 -0600, Rich Johnston <rjohnston@sgi.com> wrote:
>> On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:

>>
>> Let me know if you agree with these changes and I will make them at
>> commit time.
> Yes, please do.
>>
>> Thanks
>> --Rich

commit a3d92a6cbdf9e98d8e256974b50b025d1d4575ec
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:14 2013 +0000

     xfstest: add defragmentation stress tests for ext4

     Perform various regression tests for ext4defrag subsystem

      301'th Test1: Defragment file while other task does direct AIO
      302'th Test2: Perform defragmentation on file under buffered AIO
         while third task does direct AIO to donor file
      303'th Test3: Two defrag tasks use common donor file.
      304'th Test4: Stress defragmentation. Several threads perform
         fragmentation at random position use inplace=1 will
         allocate and free blocks inside defrag event improve
         load pressure.

     This tests are considered dangerous because 302'th and 303'th are known
     to trigger OOPS on recent kernels 
see:https://gist.github.com/dmonakhov/4770
294

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
