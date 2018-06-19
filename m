Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966263AbeFSTVQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 15:21:16 -0400
Subject: Re: Mounting xfs filesystem takes long time
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
Date: Tue, 19 Jun 2018 14:21:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180619161819.GD21698@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>
Cc: linux-xfs@vger.kernel.org

On 6/19/18 11:18 AM, Darrick J. Wong wrote:
> On Tue, Jun 19, 2018 at 02:27:29PM +0200, swadmin - levigo.de wrote:
>> Hi @all
>> I have a problem with mounting a large XFS filesystem which takes about
>> 8-10 minutes.
>>
>>
>>
>> :~# df -h /graylog_data
>> Filesystem                       Size  Used Avail Use% Mounted on
>> /dev/mapper/vgdata-graylog_data   11T  5.0T  5.1T  50% /graylog_data
>>
>> ----
>>
>> :~# xfs_info /dev/mapper/vgdata-graylog_data
>> meta-data=/dev/mapper/vgdata-graylog_data isize=512    agcount=40805,
>> agsize=65792 blks
> 
> 41,000 AGs is a lot of metadata to load.  Did someone growfs a 1G fs
> into a 11T fs?

<answer: yes, they did>

Let me state that a little more clearly: this is a badly mis-administered
filesystem; 40805 x 256MB AGs is nearly unusable, as you've seen.

If at all possible I would start over with a rationally-created filesystem
and migrate the data.

-Eric
