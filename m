Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49082 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753708AbdKINkI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 08:40:08 -0500
Subject: Re: [PATCH v3 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
References: <20171010105802.31353-1-rgoldwyn@suse.de>
 <20171010105802.31353-2-rgoldwyn@suse.de>
 <9c9e611e-b38d-e85b-98dd-40009446095d@sandeen.net>
 <2db8b7b0-e11d-99d2-1c0b-8d091d38a4bd@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c6df9793-4f20-8167-84ca-c4d416cc7290@sandeen.net>
Date: Thu, 9 Nov 2017 07:40:05 -0600
MIME-Version: 1.0
In-Reply-To: <2db8b7b0-e11d-99d2-1c0b-8d091d38a4bd@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, bfoster@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 11/9/17 6:25 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 11/08/2017 10:27 PM, Eric Sandeen wrote:
>> On 10/10/17 5:58 AM, Goldwyn Rodrigues wrote:

...

>> +		case 'N':
>> +#ifdef HAVE_PWRITEV2
>> +			pwritev2_flags |= RWF_NOWAIT;
>> +#else
>> +			printf(_("Not built with pwritev2 functionality\n"));
>> +#endif
>> +			break;
>>
> 
> I had proposed something similar (with another message) in v2, but Dave
> did not like it. I am fine to make it work either ways. Let me know.


> Note, We would have to put similar checks for -V option which would add
> some more ifdefs, which will make it a mess.

Oh, right sorry.  Dave had suggested that the default case should say:

"command -%c not supported"

to support all the configurable options, and I agree that's a better solution.

-Eric
