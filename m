Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 950DA7CBF
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 23:03:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3197CAC002
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 21:03:17 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id n5Qy6PfG81gaHFSe for
	<xfs@oss.sgi.com>; Mon, 29 Jul 2013 21:03:16 -0700 (PDT)
Message-ID: <51F73B56.1040401@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 12:04:38 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
	projids in any user namespace
References: <87txpaph4n.fsf@xmission.com>
	<1361149870-27732-1-git-send-email-ebiederm@xmission.com>
	<1361149870-27732-5-git-send-email-ebiederm@xmission.com>
	<20130219015550.GJ26694@dastard> <51F616F2.5040906@cn.fujitsu.com>
	<20130729075109.GF13468@dastard> <51F72FE6.4080202@cn.fujitsu.com>
	<20130730035748.GJ21982@dastard>
In-Reply-To: <20130730035748.GJ21982@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, dwight.engen@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>

On 07/30/2013 11:57 AM, Dave Chinner wrote:
> On Tue, Jul 30, 2013 at 11:15:50AM +0800, Gao feng wrote:
>> On 07/29/2013 03:51 PM, Dave Chinner wrote:
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028467.html
>>>
>>> Basically, the discussion we are currently having is whether project
>>> IDs should be exposed to user namespaces at all. e.g:
>>>
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028497.html
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028551.html
>>>
>>> "Basically, until we have worked out *if* project quotas can be used
>>> safely within user namespaces, we need to reject any attempt to use
>>> them from within a user namespace container."
>>>
>>
>> yes, seems this v6 patchset allows user in un-init user namespace to setup proj quota
>> through ioctl, and the projid hasn't been converted to kprojid in this patchset.
>> Doesn't this will cause user in container has the ability to change the proj quota
>> which is set by root user in host?
> 
> Dwight just posted v7. can you discuss your concerns in reposnse to
> the relevant patch in that series, please? it's much easier for
> everyone if we keep the discussion int eh one thread ;)
> 

sure, I am compiling  v7 patchset now in order to confirm my misgiving :)

Thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
